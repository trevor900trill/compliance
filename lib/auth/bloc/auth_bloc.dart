import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;
  final AuthRepository authRepository;

  AuthBloc({required this.sharedPreferences, required this.authRepository})
    : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authRepository.login(
          event.staffId,
          event.password,
          otp: event.otp,
        );
        if (response.containsKey('token')) {
          await sharedPreferences.setBool('isLoggedIn', true);
          await sharedPreferences.setString('token', response['token']);
          emit(AuthSuccess());
        } else if (response.containsKey('otp_sent') &&
            response['otp_sent'] == true) {
          emit(
            AuthOtpVerification(
              staffId: event.staffId,
              password: event.password,
            ),
          );
        } else {
          emit(
            AuthFailure(
              error: response['message'] ?? 'An unknown error occurred',
            ),
          );
        }
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await sharedPreferences.setBool('isLoggedIn', false);
      await sharedPreferences.remove('token');
      emit(AuthInitial());
    });

    on<CheckAuthStatus>((event, emit) {
      final bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    });

    on<ResendOtpRequested>((event, emit) async {
      try {
        // Request new OTP
        await authRepository.login(
          event.staffId,
          event.password,
        );
        // Stay in OTP verification state
        emit(
          AuthOtpVerification(
            staffId: event.staffId,
            password: event.password,
          ),
        );
      } catch (e) {
        // If resend fails, stay in OTP verification but could show error
        emit(
          AuthOtpVerification(
            staffId: event.staffId,
            password: event.password,
          ),
        );
      }
    });
  }
}
