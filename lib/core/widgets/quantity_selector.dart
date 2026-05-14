import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Reusable +/- quantity selector widget.
class QuantitySelector extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove, () {
            if (quantity > min) onChanged(quantity - 1);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '$quantity',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          _buildButton(Icons.add, () {
            if (quantity < max) onChanged(quantity + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: AppColors.primary),
      ),
    );
  }
}
