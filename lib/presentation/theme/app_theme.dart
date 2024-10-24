// presentation/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: const Color(0xFFFFD700),
      error: const Color(0xFFFF4545),
      surface: Colors.white,
      outline: Colors.black.withOpacity(0.1),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 144,
        fontWeight: FontWeight.w900,
      ),
      displayMedium: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 72,
        fontWeight: FontWeight.w900,
      ),
      displaySmall: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 48,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 24,
        fontWeight: FontWeight.w300,
      ),
      bodyMedium: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: const Color(0xFFFFD700),
      error: const Color(0xFFFF4545),
      surface: Colors.black,
      outline: Colors.white.withOpacity(0.1),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 144,
        fontWeight: FontWeight.w900,
      ),
      displayMedium: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 72,
        fontWeight: FontWeight.w900,
      ),
      displaySmall: TextStyle(
        //fontFamily: 'Blacker Display',
        fontSize: 48,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 24,
        fontWeight: FontWeight.w300,
      ),
      bodyMedium: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        //fontFamily: 'Graphik',
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}
