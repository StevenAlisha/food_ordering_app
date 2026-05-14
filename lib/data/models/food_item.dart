/// Represents a food/meal item in the app.
class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String categoryId;
  final double price;
  final double rating;
  final int calories;
  final int prepTime; // in minutes
  final List<String> ingredients;
  bool isFavorite;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    required this.price,
    required this.rating,
    required this.calories,
    required this.prepTime,
    required this.ingredients,
    this.isFavorite = false,
  });
}
