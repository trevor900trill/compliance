import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/bloc/auth_bloc.dart';
import '../auth/view/login_page.dart';
import '../auth/view/otp_page.dart';
import '../home/customer_management/view/customer_management_page.dart';
import '../home/enforcement/view/enforcement_page.dart';
import '../home/home_page.dart';
import '../home/inspection/view/inspection_page.dart';
import '../home/maps/view/maps_page.dart';
import '../home/services/bloc/services_bloc.dart';
import '../home/services/repository/services_repository.dart';
import '../home/services/view/services_page.dart';
import '../home/validate_document/view/validate_document_page.dart';

// Helper class to notify GoRouter of auth state changes
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(BuildContext context) {
  final authBloc = context.read<AuthBloc>();

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authBloc.state;
      final location = state.uri.toString();

      final onLoginPage = location == '/';
      final onOtpPage = location == '/otp';

      final loggingIn = onLoginPage || onOtpPage;

      if (authState is AuthInitial) {
        return onLoginPage ? null : '/';
      }

      if (authState is AuthOtpVerification) {
        return onOtpPage ? null : '/otp';
      }

      if (authState is AuthSuccess) {
        return loggingIn ? '/home' : null;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const DashboardContent(),
            routes: [
              GoRoute(
                path: 'validate_document',
                builder: (context, state) => const ValidateDocumentPage(),
              ),
              GoRoute(
                path: 'customer_management',
                builder: (context, state) => const CustomerManagementPage(),
              ),
              GoRoute(
                path: 'services',
                builder: (context, state) {
                  return RepositoryProvider(
                    create: (context) => ServicesRepository(),
                    child: BlocProvider(
                      create: (context) => ServicesBloc(
                        context.read<ServicesRepository>(),
                      )..add(FetchServices()),
                      child: const ServicesPage(),
                    ),
                  );
                },
              ),
              GoRoute(
                path: 'inspection',
                builder: (context, state) => const InspectionPage(),
              ),
              GoRoute(
                path: 'enforcement',
                builder: (context, state) => const EnforcementPage(),
              ),
              GoRoute(
                path: 'maps',
                builder: (context, state) => const MapsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
