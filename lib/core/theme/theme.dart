import 'package:flutter/material.dart';
import 'package:zibzo_app/core/constant/text_style_constant.dart';

class AppTheme {
  static border([Color color = AppPalatte.colorTransparent]) =>
      OutlineInputBorder(borderSide: BorderSide(color: color));

  static final lightThemeMode = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
          elevation: 0, backgroundColor: AppPalatte.colorTransparent),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: border(),
          border: border(),
          errorBorder: border(AppPalatte.appErrorColor),
          focusedBorder: border(AppPalatte.orangeAccent)));
}
