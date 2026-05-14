import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../utils/app_state.dart';
import '../home/home_screen.dart';
import '../categories/categories_screen.dart';
import '../favorites/favorites_screen.dart';
import '../profile/profile_screen.dart';

/// Bottom navigation wrapper that hosts the 4 main tabs.
class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.category_rounded), label: 'Categories'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: state.favorites.isNotEmpty,
              label: Text('${state.favorites.length}'),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.favorite_rounded),
            ),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
