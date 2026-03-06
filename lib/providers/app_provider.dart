import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'bubble_provider.dart';
import 'memory_provider.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _onboardingCompleted = false;
  bool _demoSeeded = false;
  DateTime _lastVisit = DateTime.now();
  StorageService? _storage;

  bool get isLoading => _isLoading;
  bool get showOnboarding => !_onboardingCompleted;
  bool get demoSeeded => _demoSeeded;
  DateTime get lastVisit => _lastVisit;

  void setStorage(StorageService storage) {
    _storage = storage;
  }

  void setFromStorage({required bool onboardingCompleted, required bool demoSeeded}) {
    _onboardingCompleted = onboardingCompleted;
    _demoSeeded = demoSeeded;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
    await _storage?.setOnboardingCompleted(true);
    notifyListeners();
  }

  Future<void> markDemoSeeded() async {
    _demoSeeded = true;
    await _storage?.setDemoSeeded(true);
    notifyListeners();
  }

  /// Resets onboarding and demo data (for developer testing). Clears flags and
  /// bubble/star data; next screen will show onboarding again.
  Future<void> resetOnboardingAndDemoData(
    BubbleProvider bubbleProvider,
    MemoryProvider memoryProvider,
  ) async {
    await _storage?.resetOnboardingAndDemoData();
    bubbleProvider.setBubbles([]);
    memoryProvider.setStars([]);
    _onboardingCompleted = false;
    _demoSeeded = false;
    notifyListeners();
  }

  void updateLastVisit() {
    _lastVisit = DateTime.now();
    notifyListeners();
  }

  bool get isNewDay {
    final now = DateTime.now();
    return now.year != _lastVisit.year ||
           now.month != _lastVisit.month ||
           now.day != _lastVisit.day;
  }
}
