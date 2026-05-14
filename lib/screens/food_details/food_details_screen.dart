import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/quantity_selector.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/models/food_item.dart';
import '../../utils/app_state.dart';

/// Food details screen — hero image, info, ingredients, add to cart.
class FoodDetailsScreen extends StatefulWidget {
  final FoodItem food;
  final String heroTagPrefix;
  const FoodDetailsScreen({super.key, required this.food, this.heroTagPrefix = 'default'});
  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    final food = widget.food;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero Image AppBar ──
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                icon: Icon(
                  food.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: food.isFavorite ? AppColors.error : Colors.white,
                ),
                onPressed: () {
                  state.toggleFavorite(food.id);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(food.isFavorite ? 'Added to favorites' : 'Removed from favorites'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: '${widget.heroTagPrefix}_food_${food.id}',
                child: Image.network(food.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.shimmer),
                ),
              ),
            ),
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Price
                  Row(
                    children: [
                      Expanded(child: Text(food.name, style: theme.textTheme.headlineSmall)),
                      Text(
                        '\$${food.price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Rating, calories, prep time
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 20),
                      const SizedBox(width: 4),
                      Text('${food.rating}', style: theme.textTheme.titleSmall),
                      const SizedBox(width: 16),
                      const Icon(Icons.local_fire_department_rounded, color: AppColors.accent, size: 20),
                      const SizedBox(width: 4),
                      Text('${food.calories} cal', style: theme.textTheme.titleSmall),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time_rounded, size: 18),
                      const SizedBox(width: 4),
                      Text('${food.prepTime} min', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('Description', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(food.description, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 20),

                  // Ingredients
                  Text('Ingredients', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: food.ingredients.map((ing) {
                      return Chip(
                        label: Text(ing, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Quantity selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Quantity', style: theme.textTheme.titleLarge),
                      QuantitySelector(
                        quantity: _quantity,
                        onChanged: (val) => setState(() => _quantity = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Add to cart button
                  CustomButton(
                    text: 'Add to Cart  •  \$${(food.price * _quantity).toStringAsFixed(2)}',
                    icon: Icons.shopping_cart_rounded,
                    onPressed: () {
                      state.addToCart(food, _quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${food.name} added to cart!')),
                      );
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
