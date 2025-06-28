import 'package:flutter/material.dart';

/// Custom color palette for GeoSME Batangas app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFD72323); // Button color - darker red
  static const Color background = Color(
    0xFFf5f5f5,
  ); // App background - light gray
  static const Color surface = Color(0xFFFFFFFF); // Card/surface color - white

  // Semantic Colors
  static const Color success = Color(0xFF38A169); // Green for success states
  static const Color warning = Color(0xFFDD6B20); // Orange for warnings
  static const Color error = Color(0xFFE53E3E); // Red for errors
  static const Color info = Color(0xFF3182CE); // Blue for info

  // Text Colors
  static const Color textPrimary = Color(0xFF1A202C); // Dark text
  static const Color textSecondary = Color(0xFF4A5568); // Secondary text
  static const Color textLight = Color(0xFF718096); // Light text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Text on primary color

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0); // Light borders
  static const Color borderMedium = Color(0xFFCBD5E0); // Medium borders
  static const Color borderDark = Color(0xFFA0AEC0); // Dark borders

  // Shadow Colors
  static const Color shadowLight = Color(
    0x1A000000,
  ); // Light shadow (10% opacity)
  static const Color shadowMedium = Color(
    0x33000000,
  ); // Medium shadow (20% opacity)
  static const Color shadowDark = Color(
    0x4D000000,
  ); // Dark shadow (30% opacity)

  // Overlay Colors
  static const Color overlayLight = Color(
    0x80000000,
  ); // Light overlay (50% opacity)
  static const Color overlayDark = Color(
    0xCC000000,
  ); // Dark overlay (80% opacity)

  // Gradient Colors (if needed)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFb05a1a)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper methods for opacity variations
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }

  static Color backgroundWithOpacity(double opacity) {
    return background.withOpacity(opacity);
  }

  static Color surfaceWithOpacity(double opacity) {
    return surface.withOpacity(opacity);
  }
}
