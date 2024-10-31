// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.black,
      primaryColor: AppColors.yellow,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.yellow,
        secondary: AppColors.green,
        surface: AppColors.black,
        background: AppColors.black,
        error: Colors.red,
      ),
      textTheme: TextTheme(
        displayLarge: AppTypography.megaTitle,
        displayMedium: AppTypography.logo,
        headlineMedium: AppTypography.heading1,
        headlineSmall: AppTypography.heading2,
        titleLarge: AppTypography.subtitle,
        bodyLarge: AppTypography.body,
        bodyMedium: AppTypography.body,
        labelSmall: AppTypography.caption,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.yellow, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        hintStyle: AppTypography.input.copyWith(
          color: AppColors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}
