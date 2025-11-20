import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';
import '../models/customer_validation_data.dart';

class CustomerValidationStep extends StatefulWidget {
  final CustomerValidationData data;
  final Function(CustomerValidationData) onDataChanged;
  final GlobalKey<FormState>? formKey;

  const CustomerValidationStep({
    super.key,
    required this.data,
    required this.onDataChanged,
    this.formKey,
  });

  @override
  State<CustomerValidationStep> createState() => _CustomerValidationStepState();
}

class _CustomerValidationStepState extends State<CustomerValidationStep> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _idNumberController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
    _idNumberController = TextEditingController(text: widget.data.idNumber);
    _mobileNumberController = TextEditingController(text: widget.data.mobileNumber);
    _otpController = TextEditingController(text: widget.data.otp);
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _mobileNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _updateData() {
    widget.data.idNumber = _idNumberController.text;
    widget.data.mobileNumber = _mobileNumberController.text;
    widget.data.otp = _otpController.text;
    widget.onDataChanged(widget.data);
  }

  List<String> _getIdTypes() {
    if (widget.data.accountType == 'Individual') {
      return ['National ID', 'Alien ID'];
    } else if (widget.data.accountType == 'Organization') {
      return ['KRA Pin', 'Business Number'];
    }
    return [];
  }

  String _getIdLabel() {
    if (widget.data.idType == 'KRA Pin') return 'KRA Pin';
    if (widget.data.idType == 'Business Number') return 'Business Number';
    return 'ID Number';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Validation',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide your account information for verification',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Account Type
              Text(
                'Account Type',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildAccountTypeCard(
                      'Individual',
                      Icons.person_outline,
                      'Personal account',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAccountTypeCard(
                      'Organization',
                      Icons.business_outlined,
                      'Business account',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ID Type
              if (widget.data.accountType != null) ...[
                Text(
                  'ID Type',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: widget.data.idType,
                  decoration: InputDecoration(
                    hintText: 'Select ID Type',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryColor),
                  ),
                  items: _getIdTypes().map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.data.idType = value;
                      _updateData();
                    });
                  },
                  validator: (value) => value == null ? 'Please select ID type' : null,
                ),
                const SizedBox(height: 16),

                // ID Number
                TextFormField(
                  controller: _idNumberController,
                  decoration: InputDecoration(
                    labelText: _getIdLabel(),
                    hintText: 'Enter ${_getIdLabel().toLowerCase()}',
                    prefixIcon: Icon(Icons.fingerprint, color: AppTheme.primaryColor),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updateData(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mobile Number
                TextFormField(
                  controller: _mobileNumberController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: '0712345678',
                    prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryColor),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _updateData(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (!RegExp(r'^0[17]\d{8}$').hasMatch(value)) {
                      return 'Enter valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // OTP Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified_user, color: AppTheme.primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'OTP Verification',
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _otpController,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          hintText: '6-digit code',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryColor),
                          suffixIcon: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('OTP sent to ${_mobileNumberController.text}'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Text('Send OTP'),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (_) => _updateData(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'OTP is required';
                          }
                          if (value.length != 6) {
                            return 'OTP must be 6 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeCard(String type, IconData icon, String subtitle) {
    final isSelected = widget.data.accountType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          widget.data.accountType = type;
          widget.data.idType = null; // Reset ID type when account type changes
          _updateData();
        });
      },
      child: AnimatedContainer(
        duration: AppTheme.mediumAnimation,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppTheme.cardShadow : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primaryColor : AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }
}
