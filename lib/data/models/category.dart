/// Represents a food category (e.g., Burgers, Pizza, etc.).
class Category {
  final String id;
  final String name;
  final String emoji; // emoji icon for display

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
  });
}
