import 'package:go_router/go_router.dart';

import '../auth/view/login_page.dart';
import '../auth/view/otp_page.dart';
import '../home/view/home_page.dart';
import '../home/view/validate_document_page.dart';
import '../home/view/customer_management_page.dart';
import '../home/view/services_page.dart';
import '../home/view/inspection_page.dart';
import '../home/view/enforcement_page.dart';
import '../home/view/maps_page.dart';

final router = GoRouter(
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
              builder: (context, state) => const ServicesPage(),
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
