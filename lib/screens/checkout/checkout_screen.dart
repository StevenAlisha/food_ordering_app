import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Checkout screen — delivery address, payment method, order summary, place order.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPayment = 0; // 0 = Cash, 1 = Credit Card
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pre-fill with user address after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = AppState.of(context);
      _addressController.text = state.user.address;
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Delivery Address ──
            Text('Delivery Address', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on_outlined),
                hintText: 'Enter your delivery address',
              ),
            ),
            const SizedBox(height: 24),

            // ── Payment Method ──
            Text('Payment Method', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _PaymentOptionTile(
              icon: Icons.money_rounded,
              title: 'Cash on Delivery',
              subtitle: 'Pay when your order arrives',
              isSelected: _selectedPayment == 0,
              onTap: () => setState(() => _selectedPayment = 0),
            ),
            const SizedBox(height: 8),
            _PaymentOptionTile(
              icon: Icons.credit_card_rounded,
              title: 'Credit Card',
              subtitle: '**** **** **** 4242',
              isSelected: _selectedPayment == 1,
              onTap: () => setState(() => _selectedPayment = 1),
            ),
            const SizedBox(height: 24),

            // ── Order Summary ──
            Text('Order Summary', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ...state.cart.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text('${item.quantity}x ', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Expanded(child: Text(item.food.name, style: theme.textTheme.bodyMedium)),
                          Text('\$${item.totalPrice.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    )),
                    const Divider(),
                    _summaryRow(theme, 'Subtotal', '\$${state.cartSubtotal.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    _summaryRow(
                      theme,
                      'Delivery',
                      state.cartDeliveryFee == 0 ? 'FREE' : '\$${state.cartDeliveryFee.toStringAsFixed(2)}',
                    ),
                    const Divider(),
                    _summaryRow(theme, 'Total', '\$${state.cartTotal.toStringAsFixed(2)}', isBold: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── Place Order Button ──
            CustomButton(
              text: 'Place Order  •  \$${state.cartTotal.toStringAsFixed(2)}',
              icon: Icons.check_circle_rounded,
              onPressed: () {
                if (_addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a delivery address')),
                  );
                  return;
                }
                // Place the order and get its ID
                final orderId = 'ORD-${1004 + state.orders.length}';
                state.placeOrder();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.orderSuccess,
                  (route) => route.settings.name == Routes.home,
                  arguments: orderId,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(ThemeData theme, String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isBold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium),
        Text(
          value,
          style: isBold
              ? theme.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)
              : theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Selectable payment method tile.
class _PaymentOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : null),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : null)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
