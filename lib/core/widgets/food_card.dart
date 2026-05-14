import 'package:flutter/material.dart';
import '../../data/models/food_item.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

/// Reusable food item card used on Home, Categories, and Favorites screens.
/// Supports Hero animation via the food item's id.
class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteTap;
  /// Prefix for Hero tag to avoid duplicates when same food appears in multiple screens.
  final String heroTagPrefix;

  const FoodCard({
    super.key,
    required this.food,
    required this.onTap,
    this.onFavoriteTap,
    this.heroTagPrefix = 'default',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Food Image with Hero animation ──
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: '${heroTagPrefix}_food_${food.id}',
                    child: Image.network(
                      food.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.shimmer,
                        child: const Icon(Icons.restaurant, size: 40, color: AppColors.textSecondaryLight),
                      ),
                    ),
                  ),
                  // Favorite button
                  if (onFavoriteTap != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavoriteTap,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            food.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: food.isFavorite ? AppColors.error : AppColors.textSecondaryLight,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ── Food Info ──
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingSM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 14),
                        const SizedBox(width: 2),
                        Text(food.rating.toString(), style: theme.textTheme.bodySmall),
                        const SizedBox(width: 6),
                        Icon(Icons.access_time_rounded, size: 12, color: theme.textTheme.bodySmall?.color),
                        const SizedBox(width: 2),
                        Text('${food.prepTime}min', style: theme.textTheme.bodySmall),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '\$${food.price.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
