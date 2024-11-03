// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const blackerDisplay = 'Blacker Display';
  static const graphik = 'Graphik';
  static const merriweather = 'Merriweather';

  // Display and Headings (Blacker Display)
  static TextStyle get megaTitle => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 126,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1,
      );

  static TextStyle get logo => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1,
      );

  static TextStyle get heading1 => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 42,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading2 => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get subtitle => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.3,
      );

  // Card Styles
  static TextStyle get cardTitle => const TextStyle(
        fontFamily: merriweather,
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.green,
        height: 1.2,
      );

  static TextStyle get cardLabel => const TextStyle(
        fontFamily: graphik,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 0,
      );

  static TextStyle get cardMetadata => TextStyle(
        fontFamily: graphik,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.74),
        height: 0,
      );

  static TextStyle get cardDate => TextStyle(
        fontFamily: merriweather,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.white.withOpacity(0.74),
        height: 0,
      );

  // Body Text
  static TextStyle get body => const TextStyle(
        fontFamily: merriweather,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get footnote => const TextStyle(
        fontFamily: graphik,
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // Input and Button Styles
  static TextStyle get input => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        height: 1,
      );

  static TextStyle get inputLabel => const TextStyle(
        fontFamily: merriweather,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        height: 1.2,
      );

  static TextStyle get inputAction => const TextStyle(
        fontFamily: merriweather,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1,
      );

  static TextStyle get button => const TextStyle(
        fontFamily: graphik,
        fontSize: 22,
        fontWeight: FontWeight.w300,
        height: 1,
      );

  static TextStyle get buttonAction => const TextStyle(
        fontFamily: merriweather,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1,
      );

  // Welcome Text
  static TextStyle get welcomeText => const TextStyle(
        fontFamily: merriweather,
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.3,
      );
}
