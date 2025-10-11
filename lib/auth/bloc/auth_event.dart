part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String staffId;
  final String password;

  LoginRequested({required this.staffId, required this.password});
}

class OtpVerified extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class NavigateToLogin extends AuthEvent {}
