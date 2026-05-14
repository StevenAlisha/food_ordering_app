import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Order tracking screen — shows order status as a stepper timeline.
class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);

    // Find the order
    final orderIndex = state.orders.indexWhere((o) => o.id == orderId);
    if (orderIndex < 0) {
      return Scaffold(
        appBar: AppBar(title: const Text('Track Order')),
        body: const Center(child: Text('Order not found')),
      );
    }
    final order = state.orders[orderIndex];

    // Status steps
    const steps = [
      _TrackingStep(icon: Icons.check_circle_rounded, title: 'Order Confirmed', subtitle: 'Your order has been received'),
      _TrackingStep(icon: Icons.restaurant_rounded, title: 'Preparing', subtitle: 'The restaurant is preparing your food'),
      _TrackingStep(icon: Icons.delivery_dining_rounded, title: 'On the Way', subtitle: 'Your rider is on the way'),
      _TrackingStep(icon: Icons.home_rounded, title: 'Delivered', subtitle: 'Enjoy your meal!'),
    ];

    final currentStep = order.status.index;

    return Scaffold(
      appBar: AppBar(title: Text('Order $orderId')),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estimated delivery card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Estimated Delivery', style: theme.textTheme.bodySmall),
                          const SizedBox(height: 4),
                          Text('25 - 35 minutes', style: theme.textTheme.titleLarge?.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Order Status', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),

            // ── Timeline stepper ──
            ...List.generate(steps.length, (index) {
              final step = steps[index];
              final isCompleted = index <= currentStep;
              final isLast = index == steps.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline indicator
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCompleted ? AppColors.primary : AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(step.icon, color: Colors.white, size: 20),
                      ),
                      if (!isLast)
                        Container(
                          width: 3,
                          height: 48,
                          color: isCompleted ? AppColors.primary : AppColors.divider,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Step content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isCompleted ? null : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(step.subtitle, style: theme.textTheme.bodySmall),
                          if (!isLast) const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),

            const Spacer(),

            // ── Order details ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order Details', style: theme.textTheme.titleMedium),
                    const Divider(),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Text('${item.quantity}x ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Expanded(child: Text(item.food.name, style: theme.textTheme.bodyMedium)),
                          Text('\$${item.totalPrice.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    )),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: theme.textTheme.titleMedium),
                        Text(
                          '\$${order.total.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            CustomButton(
              text: 'Back to Home',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _TrackingStep {
  final IconData icon;
  final String title;
  final String subtitle;
  const _TrackingStep({required this.icon, required this.title, required this.subtitle});
}
