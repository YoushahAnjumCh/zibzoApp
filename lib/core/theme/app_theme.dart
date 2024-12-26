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
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimaryLight,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.onPrimaryContainerLight,
      background: AppColors.backgroundLight,
      onBackground: AppColors.onBackgroundLight,
      onSecondary: AppColors.onSecondaryLight,
      onError: AppColors.error,
      outline: AppColors.outline,
      scrim: AppColors.onSuccess,
    ),
    textTheme: const TextTheme(),
  );

  static ThemeMode themeMode = ThemeMode.light;
}
