import 'package:flutter/material.dart';
import '../data/models/cart_item.dart';
import '../data/models/food_item.dart';
import '../data/models/order.dart';
import '../data/models/user_model.dart';
import '../data/dummy_data/dummy_user.dart';
import '../data/dummy_data/dummy_orders.dart';
import '../data/dummy_data/dummy_foods.dart';
import '../core/constants/app_constants.dart';

/// Central app state management using InheritedWidget pattern.
/// Holds cart, favorites, orders, user, and theme state.
class AppState extends StatefulWidget {
  final Widget child;
  const AppState({super.key, required this.child});

  /// Access AppState from any descendant widget.
  static AppStateData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateData>()!;
  }

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  // ── State fields ──
  List<CartItem> _cart = [];
  late List<FoodItem> _foods;
  late UserModel _user;
  late List<Order> _orders;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _foods = DummyFoods.foods;
    _user = DummyUser.user;
    _orders = DummyOrders.orders;
  }

  // ── Cart operations ──
  void addToCart(FoodItem food, [int qty = 1]) {
    setState(() {
      final index = _cart.indexWhere((item) => item.food.id == food.id);
      if (index >= 0) {
        _cart[index].quantity += qty;
      } else {
        _cart.add(CartItem(food: food, quantity: qty));
      }
    });
  }

  void removeFromCart(String foodId) {
    setState(() {
      _cart.removeWhere((item) => item.food.id == foodId);
    });
  }

  void updateCartQuantity(String foodId, int quantity) {
    setState(() {
      final index = _cart.indexWhere((item) => item.food.id == foodId);
      if (index >= 0) {
        if (quantity <= 0) {
          _cart.removeAt(index);
        } else {
          _cart[index].quantity = quantity;
        }
      }
    });
  }

  void clearCart() {
    setState(() => _cart = []);
  }

  // ── Favorites ──
  void toggleFavorite(String foodId) {
    setState(() {
      final food = _foods.firstWhere((f) => f.id == foodId);
      food.isFavorite = !food.isFavorite;
    });
  }

  // ── Orders ──
  void placeOrder() {
    if (_cart.isEmpty) return;
    final subtotal = _cart.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = subtotal >= AppConstants.freeDeliveryThreshold ? 0.0 : AppConstants.deliveryFee;
    setState(() {
      _orders.insert(
        0,
        Order(
          id: 'ORD-${1004 + _orders.length}',
          items: List.from(_cart),
          subtotal: subtotal,
          deliveryFee: deliveryFee,
          date: DateTime.now(),
          status: OrderStatus.confirmed,
        ),
      );
      _cart = [];
    });
  }

  // ── Theme ──
  void toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
  }

  // ── User ──
  void updateUser(UserModel updatedUser) {
    setState(() => _user = updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return AppStateData(
      cart: _cart,
      foods: _foods,
      user: _user,
      orders: _orders,
      isDarkMode: _isDarkMode,
      addToCart: addToCart,
      removeFromCart: removeFromCart,
      updateCartQuantity: updateCartQuantity,
      clearCart: clearCart,
      toggleFavorite: toggleFavorite,
      placeOrder: placeOrder,
      toggleTheme: toggleTheme,
      updateUser: updateUser,
      child: widget.child,
    );
  }
}

/// InheritedWidget that provides app state data to descendants.
class AppStateData extends InheritedWidget {
  final List<CartItem> cart;
  final List<FoodItem> foods;
  final UserModel user;
  final List<Order> orders;
  final bool isDarkMode;

  // Actions
  final void Function(FoodItem food, [int qty]) addToCart;
  final void Function(String foodId) removeFromCart;
  final void Function(String foodId, int quantity) updateCartQuantity;
  final VoidCallback clearCart;
  final void Function(String foodId) toggleFavorite;
  final VoidCallback placeOrder;
  final VoidCallback toggleTheme;
  final void Function(UserModel) updateUser;

  const AppStateData({
    super.key,
    required this.cart,
    required this.foods,
    required this.user,
    required this.orders,
    required this.isDarkMode,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartQuantity,
    required this.clearCart,
    required this.toggleFavorite,
    required this.placeOrder,
    required this.toggleTheme,
    required this.updateUser,
    required super.child,
  });

  // ── Computed getters ──
  int get cartItemCount => cart.fold<int>(0, (sum, item) => sum + item.quantity);
  double get cartSubtotal => cart.fold<double>(0, (sum, item) => sum + item.totalPrice);
  double get cartDeliveryFee =>
      cartSubtotal >= AppConstants.freeDeliveryThreshold ? 0.0 : AppConstants.deliveryFee;
  double get cartTotal => cartSubtotal + cartDeliveryFee;
  List<FoodItem> get favorites => foods.where((f) => f.isFavorite).toList();

  @override
  bool updateShouldNotify(AppStateData oldWidget) {
    // Always notify — setState is only called on real state changes,
    // and in-place mutations (e.g. food.isFavorite) don't change list references.
    return true;
  }
}
