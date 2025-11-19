part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String staffId;
  final String password;
  final String? otp;

  LoginRequested({required this.staffId, required this.password, this.otp});
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class NavigateToLogin extends AuthEvent {}

class ResendOtpRequested extends AuthEvent {
  final String staffId;
  final String password;

  ResendOtpRequested({required this.staffId, required this.password});
}

