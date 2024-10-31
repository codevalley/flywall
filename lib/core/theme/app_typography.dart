// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  static const blackerDisplay = 'Blacker Display';
  static const graphik = 'Graphik';

  // Core text styles (used by theme system)
  static TextStyle get megaTitle => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 126, // Reduced from 144
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1,
      );

  static TextStyle get logo => const TextStyle(
        fontFamily: graphik,
        fontSize: 56, // Reduced from 64
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        height: 1,
      );

  static TextStyle get logoItalic => logo.copyWith(
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.italic,
        color: AppColors.textSecondary,
      );

  static TextStyle get heading1 => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 42, // Reduced from 48
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get heading2 => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 32, // Reduced from 36
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get subtitle => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 21, // Reduced from 24
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle get body => const TextStyle(
        fontFamily: graphik,
        fontSize: 14, // Reduced from 16
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: graphik,
        fontSize: 12, // Reduced from 14
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // Input styles
  static TextStyle get input => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 32, // Reduced from 44
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        height: 1,
      );

  static TextStyle get inputLabel => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 21, // Reduced from 24
        fontWeight: FontWeight.w700,
        color: AppColors.white, // Changed to white for bottom sheet
        height: 1.2,
      );

  // Button styles
  static TextStyle get button => const TextStyle(
        fontFamily: graphik,
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1,
      );

  static TextStyle get buttonSerif => const TextStyle(
        fontFamily: blackerDisplay,
        fontSize: 18, // Kept original size as requested
        fontWeight: FontWeight.w400,
        height: 1,
      );
}
