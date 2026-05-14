/// Represents a user profile.
class UserModel {
  String name;
  String email;
  String phone;
  String avatarUrl;
  String address;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.address,
  });
}
