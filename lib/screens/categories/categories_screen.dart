import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/food_card.dart';
import '../../data/dummy_data/dummy_categories.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Categories screen — shows all categories with filtered food lists.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String _selectedCategory = 'cat_1';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);
    final filtered = state.foods.where((f) => f.categoryId == _selectedCategory).toList();
    final catName = DummyCategories.categories.firstWhere((c) => c.id == _selectedCategory).name;

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category chips ──
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
              itemCount: DummyCategories.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = DummyCategories.categories[index];
                return CategoryChip(
                  emoji: cat.emoji,
                  label: cat.name,
                  isSelected: _selectedCategory == cat.id,
                  onTap: () => setState(() => _selectedCategory = cat.id),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
            child: Text('$catName (${filtered.length})', style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 12),

          // ── Grid ──
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final food = filtered[index];
                return FoodCard(
                  food: food,
                  heroTagPrefix: 'categories',
                  onTap: () => Navigator.pushNamed(context, Routes.foodDetails, arguments: {'food': food, 'heroTagPrefix': 'categories'}),
                  onFavoriteTap: () => state.toggleFavorite(food.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
