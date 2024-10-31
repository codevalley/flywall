// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Core Colors
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);

  // Accent Colors
  static const green = Color(0xFF14AE5C);
  static const yellow = Color(0xFFE5A000);
  static const grey = Color(0xFF7F7F7F);

  // Text Colors (used by typography)
  static const textPrimary = white;
  static const textSecondary = grey;
  static final textDisabled = white.withOpacity(0.3);
}
