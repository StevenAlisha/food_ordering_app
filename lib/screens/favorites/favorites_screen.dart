import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/food_card.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../utils/app_state.dart';
import '../../utils/routes.dart';

/// Favorites screen — shows favorited food items in a grid.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final favorites = state.favorites;

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              subtitle: 'Tap the heart icon on any meal to add it here.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final food = favorites[index];
                return FoodCard(
                  food: food,
                  heroTagPrefix: 'favorites',
                  onTap: () => Navigator.pushNamed(context, Routes.foodDetails, arguments: {'food': food, 'heroTagPrefix': 'favorites'}),
                  onFavoriteTap: () {
                    state.toggleFavorite(food.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Removed from favorites'), duration: Duration(seconds: 1)),
                    );
                  },
                );
              },
            ),
    );
  }
}
