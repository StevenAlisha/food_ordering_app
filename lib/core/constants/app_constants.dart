/// App-wide constants for padding, durations, and string values.
class AppConstants {
  AppConstants._();

  // App info
  static const String appName = 'FoodDash';
  static const String appTagline = 'Delicious food, delivered fast';

  // Padding / spacing
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // Durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration animDuration = Duration(milliseconds: 300);

  // Delivery fee
  static const double deliveryFee = 2.99;
  static const double freeDeliveryThreshold = 25.0;
}
