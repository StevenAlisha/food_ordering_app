import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'utils/app_state.dart';
import 'utils/routes.dart';
import 'core/constants/app_constants.dart';

/// Root MaterialApp with theme support and named routing.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // Theme switching based on app state
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // Named route navigation
      initialRoute: Routes.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
