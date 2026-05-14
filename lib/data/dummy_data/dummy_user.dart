import '../models/user_model.dart';

/// Dummy user data for the profile screen.
class DummyUser {
  DummyUser._();

  static UserModel user = UserModel(
    name: 'Steven Alisha',
    email: 'stevenalisha@gmail.com',
    phone: '+20 1234 567 890',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    address: '15 El-Tahrir St, Downtown, Cairo, Egypt',
  );
}
