import 'package:flutter/material.dart';

import '../../theme.dart';
import '../router.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    final router = createRouter(context);
    return MaterialApp.router(
      title: 'NCG Portal',
      theme: AppTheme.theme,
      routerConfig: router,
    );
  }
}
