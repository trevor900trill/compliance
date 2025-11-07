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
import '../home/services/view/advertisement_page.dart';
import '../home/services/view/fire_disaster_management_page.dart';
import '../home/services/view/land_rates_bill_page.dart';
import '../home/services/view/services_page.dart';
import '../home/services/view/unified_business_permit_page.dart';
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
      // Using `state.matchedLocation` is more robust as it ignores query parameters.
      final location = state.matchedLocation;

      // Define which routes are part of the authentication flow.
      final isAuthRoute = location == '/' || location == '/otp';

      // Check the authentication state.
      if (authState is AuthSuccess) {
        // If the user is authenticated and on an auth route, redirect to home.
        return isAuthRoute ? '/home' : null;
      }

      if (authState is AuthOtpVerification) {
        // If the user needs to verify OTP, redirect them to the OTP page
        // unless they are already there.
        return location == '/otp' ? null : '/otp';
      }

      // For any other state (AuthInitial, AuthLoading, AuthFailure),
      // if the user is not on an auth route, redirect them to the login page.
      // This handles logout and initial app load.
      return isAuthRoute ? null : '/';
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/otp', builder: (context, state) => const OtpPage()),
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

              // GoRoute(
              //   path: 'services',
              //   builder: (context, state) {
              //     return RepositoryProvider(
              //       create: (context) => ServicesRepository(),
              //       child: BlocProvider(
              //         create: (context) =>
              //             ServicesBloc(context.read<ServicesRepository>())
              //               ..add(FetchServices()),
              //         child: const ServicesPage(),
              //       ),
              //     );
              //   },
              // ),
              GoRoute(
                path: 'services',
                builder: (context, state) => const ServicesPage(),
                routes: [
                  GoRoute(
                    path: 'unified_business_permit',
                    builder: (context, state) =>
                        const UnifiedBusinessPermitPage(),
                  ),
                  GoRoute(
                    path: 'land_rates_bill',
                    builder: (context, state) => const LandRatesBillPage(),
                  ),
                  GoRoute(
                    path: 'fire_disaster_management',
                    builder: (context, state) =>
                        const FireDisasterManagementPage(),
                  ),
                  GoRoute(
                    path: 'advertisement',
                    builder: (context, state) => const AdvertisementPage(),
                  ),
                ],
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
