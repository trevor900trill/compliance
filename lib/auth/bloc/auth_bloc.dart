import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences sharedPreferences;

  AuthBloc({required this.sharedPreferences}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      // In a real app, you would authenticate with a backend.
      // For this example, we'll just simulate a successful login.
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay
      if (event.staffId == '1234' && event.password == 'password') {
        emit(AuthOtpVerification());
      } else {
        emit(AuthFailure(error: 'Invalid credentials'));
      }
    });

    on<OtpVerified>((event, emit) async {
      await sharedPreferences.setBool('isLoggedIn', true);
      emit(AuthSuccess());
    });

    on<LogoutRequested>((event, emit) async {
      await sharedPreferences.setBool('isLoggedIn', false);
      emit(AuthInitial());
    });

    on<CheckAuthStatus>((event, emit) {
      final isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        emit(AuthSuccess());
      } else {
        emit(AuthInitial());
      }
    });
  }
}
