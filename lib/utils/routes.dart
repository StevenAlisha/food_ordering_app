import 'package:flutter/material.dart';
import '../data/models/food_item.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/bottom_nav_wrapper.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/food_details/food_details_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/checkout/checkout_screen.dart';
import '../screens/checkout/order_success_screen.dart';
import '../screens/order_tracking/order_tracking_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';

/// Named route constants.
class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String foodDetails = '/food-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String orderTracking = '/order-tracking';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String settings = '/settings';

  /// Route generator for MaterialApp.onGenerateRoute.
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const BottomNavWrapper());
      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case foodDetails:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => FoodDetailsScreen(
          food: args['food'] as FoodItem,
          heroTagPrefix: args['heroTagPrefix'] as String? ?? 'default',
        ));
      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());
      case orderSuccess:
        final orderId = routeSettings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderSuccessScreen(orderId: orderId));
      case orderTracking:
        final orderId = routeSettings.arguments as String;
        return MaterialPageRoute(builder: (_) => OrderTrackingScreen(orderId: orderId));
      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${routeSettings.name} not found')),
          ),
        );
    }
  }
}
