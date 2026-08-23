import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class OwnitApp extends StatelessWidget {
  const OwnitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OWNIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
