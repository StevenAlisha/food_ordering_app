import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/search_bar_widget.dart';
import '../../core/widgets/category_chip.dart';
import '../../core/widgets/food_card.dart';
import '../../data/dummy_data/dummy_categories.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Home screen — greeting, search, categories, popular meals, and promo banner.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = '';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final theme = Theme.of(context);

    // Filter foods
    var foods = state.foods;
    if (_selectedCategory.isNotEmpty) {
      foods = foods.where((f) => f.categoryId == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      foods = foods.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppConstants.paddingMD, AppConstants.paddingMD, AppConstants.paddingMD, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting + cart button
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hello, ${state.user.name.split(' ').first} 👋', style: theme.textTheme.headlineSmall),
                              const SizedBox(height: 4),
                              Text('What would you like to eat?', style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        // Cart icon with badge
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, Routes.cart),
                          child: Badge(
                            isLabelVisible: state.cartItemCount > 0,
                            label: Text('${state.cartItemCount}'),
                            backgroundColor: AppColors.primary,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: theme.cardTheme.color,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                              ),
                              child: const Icon(Icons.shopping_cart_rounded),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    SearchBarWidget(
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: 20),

                    // ── Promo Banner ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Free Delivery!', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text('On orders above \$${AppConstants.freeDeliveryThreshold.toStringAsFixed(0)}', style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13)),
                              ],
                            ),
                          ),
                          const Icon(Icons.local_offer_rounded, color: Colors.white, size: 48),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Categories ──
                    Text('Categories', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Category chips — horizontal scroll
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
                  itemCount: DummyCategories.categories.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CategoryChip(
                        emoji: '🔥',
                        label: 'All',
                        isSelected: _selectedCategory.isEmpty,
                        onTap: () => setState(() => _selectedCategory = ''),
                      );
                    }
                    final cat = DummyCategories.categories[index - 1];
                    return CategoryChip(
                      emoji: cat.emoji,
                      label: cat.name,
                      isSelected: _selectedCategory == cat.id,
                      onTap: () => setState(() => _selectedCategory = cat.id),
                    );
                  },
                ),
              ),
            ),

            // ── Section title ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppConstants.paddingMD, 24, AppConstants.paddingMD, 12),
                child: Text(
                  _selectedCategory.isEmpty ? 'Popular Meals 🔥' : 'Results',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),

            // ── Food grid ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMD),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final food = foods[index];
                    return FoodCard(
                      food: food,
                      heroTagPrefix: 'home',
                      onTap: () => Navigator.pushNamed(context, Routes.foodDetails, arguments: {'food': food, 'heroTagPrefix': 'home'}),
                      onFavoriteTap: () {
                        state.toggleFavorite(food.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(food.isFavorite ? 'Added to favorites' : 'Removed from favorites'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                  childCount: foods.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
