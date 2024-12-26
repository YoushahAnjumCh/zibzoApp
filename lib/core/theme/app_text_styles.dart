import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle headlineLight = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryLight,
  );

  static const TextStyle bodyLight = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackgroundLight,
  );

  static const TextStyle headlineDark = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryDark,
  );

  static const TextStyle bodyDark = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackgroundDark,
  );
  static const TextStyle headingLight = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryLight,
  );
}
