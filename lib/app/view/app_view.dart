import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/view/login_page.dart';
import '../../auth/view/otp_page.dart';
import '../../home/view/home_page.dart';
import '../../theme.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NCG Portal',
      theme: AppTheme.theme,
      routerConfig: _getRouter(context),
    );
  }

  GoRouter _getRouter(BuildContext context) {
    return GoRouter(
      refreshListenable: GoRouterRefreshStream(
        context.watch<AuthBloc>().stream,
      ),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/otp',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const OtpPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthBloc>().state;
        final isLoggedIn = authState is AuthSuccess;
        final isOtpVerification = authState is AuthOtpVerification;

        final isLoggingIn = state.matchedLocation == '/';
        final isVerifyingOtp = state.matchedLocation == '/otp';

        if (!isLoggedIn && !isLoggingIn && !isOtpVerification) {
          return '/';
        }

        if (isOtpVerification && !isVerifyingOtp) {
          return '/otp';
        }

        if (isLoggedIn && (isLoggingIn || isVerifyingOtp)) {
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
