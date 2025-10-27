import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/view/app_view.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/repository/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(
    sharedPreferences: sharedPreferences,
    authRepository: AuthRepository(),
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final AuthRepository authRepository;

  const MyApp({
    super.key,
    required this.sharedPreferences,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        sharedPreferences: sharedPreferences,
        authRepository: authRepository,
      )..add(CheckAuthStatus()),
      child: const AppView(),
    );
  }
}
