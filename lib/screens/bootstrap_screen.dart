import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_provider.dart';
import '../providers/bubble_provider.dart';
import '../providers/memory_provider.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

/// Loads persisted state and shows either onboarding or the main app.
class BootstrapScreen extends StatefulWidget {
  const BootstrapScreen({super.key});

  @override
  State<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends State<BootstrapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = StorageService(prefs);

    if (!mounted) return;
    final app = context.read<AppProvider>();
    final bubbleProvider = context.read<BubbleProvider>();
    final memoryProvider = context.read<MemoryProvider>();

    app.setStorage(storage);
    bubbleProvider.setStorage(storage);
    memoryProvider.setStorage(storage);

    app.setFromStorage(
      onboardingCompleted: storage.onboardingCompleted,
      demoSeeded: storage.demoSeeded,
    );

    final bubbles = storage.loadBubbles();
    if (bubbles.isNotEmpty) {
      bubbleProvider.setBubbles(bubbles);
    }
    final stars = storage.loadStars();
    if (stars.isNotEmpty) {
      memoryProvider.setStars(stars);
    }

    if (!mounted) return;
    app.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, app, _) {
        if (app.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bubble_chart,
                    size: 48,
                    color: AppColors.primaryWithOpacity(0.7),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bubble Therapy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
          );
        }
        if (app.showOnboarding) {
          return const OnboardingScreen();
        }
        return const MainScreen();
      },
    );
  }
}
