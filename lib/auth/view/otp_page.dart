import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/auth/bloc/auth_bloc.dart';
import 'package:myapp/theme.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _canResend = true);
      }
    });
  }

  void _resendOtp() {
    final authState = context.read<AuthBloc>().state as AuthOtpVerification;
    context.read<AuthBloc>().add(
          ResendOtpRequested(
            staffId: authState.staffId,
            password: authState.password,
          ),
        );
    _startTimer();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('OTP sent successfully!'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleBackToLogin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Go Back?', style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to return to the login page?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutRequested());
            },
            child: Text('Yes, Go Back'),
          ),
        ],
      ),
    );
  }

  Color _getTimerColor() {
    if (_secondsRemaining > 40) return AppTheme.primaryColor;
    if (_secondsRemaining > 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state as AuthOtpVerification;
    final staffId = authState.staffId;
    final password = authState.password;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(child: Text(state.error)),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.primaryColor.withOpacity(0.05),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _handleBackToLogin,
                          icon: Icon(Icons.arrow_back, size: 20),
                          label: Text('Back to Login'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Lock Icon with Gradient
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Title
                      Text(
                        'OTP Verification',
                        style: GoogleFonts.lato(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        'Enter the 4-digit code sent to your registered mobile number',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // OTP Input
                      OtpInput(staffId: staffId, password: password),
                      const SizedBox(height: 40),
                      
                      // Timer Display with Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: _canResend ? 0 : _secondsRemaining / 60,
                              strokeWidth: 4,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation(_getTimerColor()),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                _canResend ? '0:00' : '0:${_secondsRemaining.toString().padLeft(2, '0')}',
                                style: GoogleFonts.lato(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: _getTimerColor(),
                                ),
                              ),
                              Text(
                                _canResend ? 'Expired' : 'remaining',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Resend OTP Button
                      AnimatedOpacity(
                        opacity: _canResend ? 1.0 : 0.5,
                        duration: AppTheme.mediumAnimation,
                        child: OutlinedButton.icon(
                          onPressed: _canResend ? _resendOtp : null,
                          icon: Icon(Icons.refresh),
                          label: Text('Resend OTP'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryColor,
                            side: BorderSide(color: AppTheme.primaryColor),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonBorderRadius),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Help Text
                      Text(
                        'Didn\'t receive the code?',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtpInput extends StatefulWidget {
  const OtpInput({super.key, required this.staffId, required this.password});
  final String staffId;
  final String password;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: GoogleFonts.lato(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppTheme.primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppTheme.primaryColor.withOpacity(0.1),
        border: Border.all(color: AppTheme.primaryColor, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    return Column(
      children: [
        Pinput(
          length: 4,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          onCompleted: (pin) {
            setState(() => _isLoading = true);
            context.read<AuthBloc>().add(
                  LoginRequested(
                    staffId: widget.staffId,
                    password: widget.password,
                    otp: pin,
                  ),
                );
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) setState(() => _isLoading = false);
            });
          },
        ),
        if (_isLoading) ...[
          SizedBox(height: 16),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
            ),
          ),
        ],
      ],
    );
  }
}

