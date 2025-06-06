import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryLight,
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.onPrimaryLight,
      titleTextStyle: TextStyle(color: AppColors.onPrimaryLight),
      iconTheme: IconThemeData(color: AppColors.onPrimaryLight),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.onPrimaryLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.onPrimaryContainerLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFieldFillColor,
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        onPrimary: AppColors.onPrimaryLight,
        primaryContainer: AppColors.primaryContainerLight,
        onPrimaryContainer: AppColors.onPrimaryContainerLight,
        onSecondary: AppColors.onSecondaryLight,
        error: AppColors.error,
        outline: AppColors.outline,
        onSurface: AppColors.darkBlackBlue,
        scrim: AppColors.onSuccess,
        surface: AppColors.categoryLightBlue),
    textTheme: const TextTheme(),
  );

  static ThemeMode themeMode = ThemeMode.light;
}
