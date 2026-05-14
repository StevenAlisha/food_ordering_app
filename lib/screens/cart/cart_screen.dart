import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Cart screen — shows cart items, quantity controls, order summary.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (state.cart.isNotEmpty)
            TextButton(
              onPressed: () {
                state.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cart cleared')),
                );
              },
              child: const Text('Clear All'),
            ),
        ],
      ),
      body: state.cart.isEmpty
          ? EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add some delicious meals to your cart!',
              actionLabel: 'Browse Meals',
              onAction: () => Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false),
            )
          : Column(
              children: [
                // ── Cart items list ──
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppConstants.paddingMD),
                    itemCount: state.cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.cart[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              // Food image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.food.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    color: AppColors.shimmer,
                                    child: const Icon(Icons.restaurant),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Name + price
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.food.name,
                                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 8),
                                    QuantitySelector(
                                      quantity: item.quantity,
                                      min: 0,
                                      onChanged: (val) {
                                        if (val == 0) {
                                          state.removeFromCart(item.food.id);
                                        } else {
                                          state.updateCartQuantity(item.food.id, val);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Delete button
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                                onPressed: () {
                                  state.removeFromCart(item.food.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item.food.name} removed from cart')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Order summary ──
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingMD),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(theme, 'Subtotal', '\$${state.cartSubtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        theme,
                        'Delivery Fee',
                        state.cartDeliveryFee == 0 ? 'FREE' : '\$${state.cartDeliveryFee.toStringAsFixed(2)}',
                        isHighlight: state.cartDeliveryFee == 0,
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(theme, 'Total', '\$${state.cartTotal.toStringAsFixed(2)}', isBold: true),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Proceed to Checkout',
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => Navigator.pushNamed(context, Routes.checkout),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSummaryRow(ThemeData theme, String label, String value, {bool isBold = false, bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isBold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium),
        Text(
          value,
          style: isBold
              ? theme.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)
              : isHighlight
                  ? theme.textTheme.bodyMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)
                  : theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
