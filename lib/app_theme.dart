// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryLight = Color(0xFfA8E82F); // Blue
  static const Color primaryDark = Color(0xFF009688); // Teal

  static const Color secondaryLight = Color(0xFFE6FFB8); // Light Blue
  static const Color secondaryDark = Color(0xFF4DB6AC); // Teal Light

  // Background & surface
  static const Color scaffoldLight = Colors.white;
  static const Color scaffoldDark = Color(0xFF121212); // true dark

  static const Color surfaceLight = Color(0xFFF5F5F5); // Light gray
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimaryLight = Colors.black;
  static const Color textSecondaryLight = Colors.black54;
  static const Color textDisabledLight = Colors.black38;

  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Colors.white70;
  static const Color textDisabledDark = Colors.white38;

  // Status colors
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);
  static const Color success = Color(0xFF388E3C);
  static const Color info = Color(0xFF1976D2);

  // Borders and dividers
  static const Color borderLight = Color(0xFFDDDDDD);
  static const Color borderDark = Color(0xFF2C2C2C);

  // Shadows
  static const Color shadowLight = Colors.black12;
  static const Color shadowDark = Colors.black54;
}

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryLight,
      onPrimary: AppColors.textPrimaryDark,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimaryDark,
      background: AppColors.scaffoldLight,
      onBackground: AppColors.textPrimaryLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: AppColors.textPrimaryDark, fontSize: 20),
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryLight, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryLight),
    ),
  );

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryDark,
      onPrimary: AppColors.textPrimaryDark,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.textPrimaryDark,
      background: AppColors.scaffoldDark,
      onBackground: AppColors.textPrimaryDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldDark,
    appBarTheme: const AppBarTheme(
    //  backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: AppColors.textPrimaryDark, fontSize: 20),
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimaryDark, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryDark),
    ),
  );
}

