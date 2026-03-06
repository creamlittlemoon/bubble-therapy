import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/bubble_provider.dart';
import '../providers/memory_provider.dart';
import '../theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<({String title, String body, IconData icon})> _pages = [
    (
      title: 'Release daily worries',
      body: 'This app helps you let go of what weighs on you—one worry at a time.',
      icon: Icons.psychology_outlined,
    ),
    (
      title: 'Worries become bubbles',
      body: 'Each worry you write turns into a bubble. Hold it, then release it when you\'re ready.',
      icon: Icons.bubble_chart_outlined,
    ),
    (
      title: 'Build emotional memory',
      body: 'Coming back daily builds a gentle practice. Small steps create lasting change.',
      icon: Icons.auto_awesome_outlined,
    ),
    (
      title: 'Stars in Memory Sky',
      body: 'Released bubbles become stars in your Memory Sky—a quiet place to remember what you\'ve let go.',
      icon: Icons.star_border_outlined,
    ),
  ];

  Future<void> _finishOnboarding() async {
    final app = context.read<AppProvider>();
    final bubbleProvider = context.read<BubbleProvider>();
    final memoryProvider = context.read<MemoryProvider>();

    await app.completeOnboarding();

    if (!app.demoSeeded) {
      final released = bubbleProvider.seedDemoData();
      for (final bubble in released) {
        memoryProvider.addStar(
          bubble,
          releasedAt: bubble.createdAt.add(const Duration(hours: 1)),
        );
      }
      await app.markDemoSeeded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 24),
                        Icon(
                          page.icon,
                          size: 64,
                          color: AppColors.primaryWithOpacity(0.9),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 100.ms, duration: 350.ms)
                            .slideY(begin: 0.1, end: 0),
                        const SizedBox(height: 16),
                        Text(
                          page.body,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 350.ms)
                            .slideY(begin: 0.08, end: 0),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicators
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            // CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                      );
                    } else {
                      await _finishOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get started',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
