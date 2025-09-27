import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter the OTP sent to your device'),
            const SizedBox(height: 20),
            // In a real app, you would have a text field for the OTP.
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(OtpVerified());
                context.go('/home');
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}