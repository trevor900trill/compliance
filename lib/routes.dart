import 'package:flutter/material.dart';
import 'package:myapp/auth/view/otp_page.dart';
import 'package:myapp/home/view/home_page.dart';

class AppRoutes {
  static Route<dynamic> _slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static Route<dynamic> get home => _slideTransition(const HomePage());
  static Route<dynamic> get otp => _slideTransition(const OtpPage());
}
