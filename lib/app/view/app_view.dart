import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/view/login_page.dart';
import '../../auth/view/otp_page.dart';
// import '../../core/theme_provider.dart';
import '../../home/view/home_page.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      routerConfig: _getRouter(context),
    );
  }

  GoRouter _getRouter(BuildContext context) {
    return GoRouter(
      refreshListenable: GoRouterRefreshStream(context.watch<AuthBloc>().stream),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) => const OtpPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthBloc>().state;
        final isLoggedIn = authState is AuthSuccess;

        final isLoggingIn = state.matchedLocation == '/';

        if (!isLoggedIn && !isLoggingIn) {
          return '/';
        }

        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }

        return null;
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}