import 'food_item.dart';

/// Represents an item in the shopping cart with quantity.
class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({
    required this.food,
    this.quantity = 1,
  });

  /// Total price for this cart item (price × quantity).
  double get totalPrice => food.price * quantity;
}
