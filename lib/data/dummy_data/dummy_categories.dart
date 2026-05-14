import '../models/category.dart';

/// Dummy categories for the food ordering app.
class DummyCategories {
  DummyCategories._();

  static const List<Category> categories = [
    Category(id: 'cat_1', name: 'Burgers', emoji: '🍔'),
    Category(id: 'cat_2', name: 'Pizza', emoji: '🍕'),
    Category(id: 'cat_3', name: 'Sushi', emoji: '🍣'),
    Category(id: 'cat_4', name: 'Pasta', emoji: '🍝'),
    Category(id: 'cat_5', name: 'Desserts', emoji: '🍰'),
    Category(id: 'cat_6', name: 'Drinks', emoji: '🥤'),
    Category(id: 'cat_7', name: 'Salads', emoji: '🥗'),
    Category(id: 'cat_8', name: 'Chicken', emoji: '🍗'),
  ];
}
