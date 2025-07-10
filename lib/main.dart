import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GeoSME Batangas 2024',
      home: const LandingScreen(),
      theme: ThemeData(
        fontFamily: 'Poppins', // Default font family
        // Custom colors
        primaryColor: AppColors.primary, // Button color
        scaffoldBackgroundColor: AppColors.background, // App background
        cardColor: AppColors.surface, // Card background
        // Color scheme based on your primary color
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
          surface: AppColors.surface,
        ),

        // App bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 1,
          iconTheme: const IconThemeData(color: AppColors.primary),
        ),

        // Card theme
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primaryWithOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }
}

// Custom colors extension for easy access
class CustomColors extends ThemeExtension<CustomColors> {
  final Color geosmeRed;
  final Color geosmeBlue;
  final Color geosmeGreen;
  final Color geosmeOrange;

  const CustomColors({
    required this.geosmeRed,
    required this.geosmeBlue,
    required this.geosmeGreen,
    required this.geosmeOrange,
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? geosmeRed,
    Color? geosmeBlue,
    Color? geosmeGreen,
    Color? geosmeOrange,
  }) {
    return CustomColors(
      geosmeRed: geosmeRed ?? this.geosmeRed,
      geosmeBlue: geosmeBlue ?? this.geosmeBlue,
      geosmeGreen: geosmeGreen ?? this.geosmeGreen,
      geosmeOrange: geosmeOrange ?? this.geosmeOrange,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
    ThemeExtension<CustomColors>? other,
    double t,
  ) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      geosmeRed: Color.lerp(geosmeRed, other.geosmeRed, t)!,
      geosmeBlue: Color.lerp(geosmeBlue, other.geosmeBlue, t)!,
      geosmeGreen: Color.lerp(geosmeGreen, other.geosmeGreen, t)!,
      geosmeOrange: Color.lerp(geosmeOrange, other.geosmeOrange, t)!,
    );
  }
}
