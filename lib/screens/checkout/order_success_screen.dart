import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../utils/routes.dart';

/// Order success screen — shown after placing an order.
class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, size: 80, color: AppColors.success),
              ),
              const SizedBox(height: 32),
              Text('Order Placed!', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                'Your order $orderId has been placed successfully.\nEstimated delivery: 25-35 minutes.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Track Order button
              CustomButton(
                text: 'Track Order',
                icon: Icons.local_shipping_rounded,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.orderTracking, arguments: orderId);
                },
              ),
              const SizedBox(height: 12),

              // Back to Home button
              CustomButton(
                text: 'Back to Home',
                isOutlined: true,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
