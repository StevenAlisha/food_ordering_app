import '../models/order.dart';
import '../models/cart_item.dart';
import 'dummy_foods.dart';

/// Dummy order history for the profile screen.
class DummyOrders {
  DummyOrders._();

  static List<Order> orders = [
    Order(
      id: 'ORD-1001',
      items: [
        CartItem(food: DummyFoods.foods[0], quantity: 2),
        CartItem(food: DummyFoods.foods[10], quantity: 1),
      ],
      subtotal: 23.47,
      deliveryFee: 2.99,
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: OrderStatus.delivered,
    ),
    Order(
      id: 'ORD-1002',
      items: [
        CartItem(food: DummyFoods.foods[2], quantity: 1),
        CartItem(food: DummyFoods.foods[8], quantity: 2),
      ],
      subtotal: 28.97,
      deliveryFee: 0.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: OrderStatus.delivered,
    ),
    Order(
      id: 'ORD-1003',
      items: [
        CartItem(food: DummyFoods.foods[4], quantity: 1),
        CartItem(food: DummyFoods.foods[6], quantity: 1),
      ],
      subtotal: 30.48,
      deliveryFee: 0.0,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      status: OrderStatus.onTheWay,
    ),
  ];
}
