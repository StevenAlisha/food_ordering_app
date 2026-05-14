import 'cart_item.dart';

/// Possible states of an order.
enum OrderStatus { confirmed, preparing, onTheWay, delivered }

/// Represents a placed order.
class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final DateTime date;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.date,
    this.status = OrderStatus.confirmed,
  });

  /// Total amount including delivery fee.
  double get total => subtotal + deliveryFee;

  /// Human-readable status label.
  String get statusLabel {
    switch (status) {
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.onTheWay:
        return 'On the Way';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }
}
