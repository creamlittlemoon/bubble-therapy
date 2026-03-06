import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Keys for first-time user state and persisted data.
abstract final class StorageKeys {
  static const String onboardingCompleted = 'onboarding_completed';
  static const String demoSeeded = 'demo_seeded';
  static const String bubbles = 'bubbles';
  static const String stars = 'stars';
}

/// Persists onboarding/demo flags and bubble/star data to SharedPreferences.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  // --- Onboarding & demo flags ---
  bool get onboardingCompleted =>
      _prefs.getBool(StorageKeys.onboardingCompleted) ?? false;

  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(StorageKeys.onboardingCompleted, value);
  }

  bool get demoSeeded => _prefs.getBool(StorageKeys.demoSeeded) ?? false;

  Future<void> setDemoSeeded(bool value) async {
    await _prefs.setBool(StorageKeys.demoSeeded, value);
  }

  // --- Bubbles ---
  List<Bubble> loadBubbles() {
    final json = _prefs.getString(StorageKeys.bubbles);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => Bubble.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveBubbles(List<Bubble> bubbles) async {
    final list = bubbles.map((b) => b.toJson()).toList();
    await _prefs.setString(StorageKeys.bubbles, jsonEncode(list));
  }

  // --- Stars ---
  List<Star> loadStars() {
    final json = _prefs.getString(StorageKeys.stars);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => Star.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveStars(List<Star> stars) async {
    final list = stars.map((s) => s.toJson()).toList();
    await _prefs.setString(StorageKeys.stars, jsonEncode(list));
  }

  /// Resets onboarding, demo flag, and all persisted bubbles/stars (for dev/testing).
  Future<void> resetOnboardingAndDemoData() async {
    await _prefs.remove(StorageKeys.onboardingCompleted);
    await _prefs.remove(StorageKeys.demoSeeded);
    await _prefs.remove(StorageKeys.bubbles);
    await _prefs.remove(StorageKeys.stars);
  }
}
