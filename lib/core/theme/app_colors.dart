import 'package:flutter/material.dart';

/// Centralized color palette for the food ordering app.
/// Uses an orange/red food-themed color scheme.
class AppColors {
  AppColors._();

  // Primary palette
  static const Color primary = Color(0xFFFF5722);
  static const Color primaryLight = Color(0xFFFF8A65);
  static const Color primaryDark = Color(0xFFE64A19);

  // Accent
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFCC80);

  // Backgrounds
  static const Color scaffoldLight = Color(0xFFF9F9F9);
  static const Color scaffoldDark = Color(0xFF121212);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color surfaceDark = Color(0xFF2C2C2C);

  // Text
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Misc
  static const Color starYellow = Color(0xFFFFD700);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shimmer = Color(0xFFEEEEEE);
}
