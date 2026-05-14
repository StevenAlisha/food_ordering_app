import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/custom_button.dart';
import '../../utils/routes.dart';

/// Onboarding screen with 3 swipeable pages introducing the app.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Onboarding page data
  static const List<_OnboardingPage> _pages = [
    _OnboardingPage(
      icon: Icons.restaurant_menu_rounded,
      title: 'Browse Meals',
      subtitle: 'Explore hundreds of delicious meals from top restaurants near you.',
    ),
    _OnboardingPage(
      icon: Icons.delivery_dining_rounded,
      title: 'Fast Delivery',
      subtitle: 'Get your food delivered to your doorstep in 30 minutes or less.',
    ),
    _OnboardingPage(
      icon: Icons.thumb_up_alt_rounded,
      title: 'Easy Ordering',
      subtitle: 'Order with just a few taps. Pay online or with cash on delivery.',
    ),
  ];

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _goToLogin,
                child: const Text('Skip'),
              ),
            ),
            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon in a gradient circle
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary.withValues(alpha: 0.15), AppColors.accent.withValues(alpha: 0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(page.icon, size: 80, color: AppColors.primary),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: theme.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicator
            SmoothPageIndicator(
              controller: _controller,
              count: _pages.length,
              effect: const ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.divider,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
            ),
            const SizedBox(height: 32),
            // Next / Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
              child: CustomButton(
                text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _controller.nextPage(
                      duration: AppConstants.animDuration,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _goToLogin();
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

/// Data class for onboarding page content.
class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
