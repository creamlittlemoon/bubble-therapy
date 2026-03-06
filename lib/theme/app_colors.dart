import 'package:flutter/material.dart';

/// Centralized color palette for Bubble Therapy.
/// Calm blue-gray family with a warm accent. Keeps contrast accessible
/// and the app premium, soft, and minimal.
abstract final class AppColors {
  AppColors._();

  // --- Core palette (5 main colors) ---
  /// Primary brand blue — CTAs, links, selected states, bubbles.
  static const Color primary = Color(0xFF6B9AC4);

  /// Warm accent — secondary actions, highlights, warmth.
  static const Color secondary = Color(0xFFE8A87C);

  /// Main background and surface.
  static const Color surface = Color(0xFFF7F9FC);

  /// Primary text — headings, important copy.
  static const Color textPrimary = Color(0xFF2D3748);

  /// Muted text — body, captions, hints.
  static const Color textMuted = Color(0xFF718096);

  // --- Supporting neutrals (harmonized with core) ---
  /// Body text — slightly darker than muted where needed.
  static const Color textSecondary = Color(0xFF4A5568);

  /// Placeholder, disabled text, subtle labels.
  static const Color textHint = Color(0xFFA0AEC0);

  /// Borders, dividers, subtle lines.
  static const Color border = Color(0xFFE2E8F0);

  /// Cards, input backgrounds, alternate surfaces.
  static const Color surfaceVariant = Color(0xFFEDF2F7);

  /// Disabled controls, inactive.
  static const Color disabled = Color(0xFFCBD5E0);

  /// Dark surface (e.g. memory sky).
  static const Color surfaceDark = Color(0xFF1A202C);

  /// On-primary text (buttons, primary surfaces).
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// On dark surface text.
  static const Color onSurfaceDark = Color(0xFFA0AEC0);

  /// Light accent on dark (e.g. reflection text in Memory Sky).
  static const Color primaryLight = Color(0xFF90CDF4);

  // --- Semantic / emotion (for insights, etc.) ---
  static const Color emotionAnxious = Color(0xFF9F7AEA);
  static const Color emotionSad = Color(0xFF63B3ED);
  static const Color emotionAngry = Color(0xFFFC8181);
  static const Color emotionStressed = Color(0xFFE8A87C);
  static const Color emotionTired = Color(0xFF718096);
  static const Color emotionLonely = Color(0xFF4A5568);

  /// Accent for positive/success (e.g. Released stat).
  static const Color accentGreen = Color(0xFF7C9885);

  // --- Helpers ---
  static Color primaryWithOpacity(double opacity) => primary.withOpacity(opacity);
  static Color secondaryWithOpacity(double opacity) =>
      secondary.withOpacity(opacity);
}
