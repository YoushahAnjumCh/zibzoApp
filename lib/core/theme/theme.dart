import 'package:flutter/material.dart';
import 'package:zibzo_app/core/theme/color_theme.dart';
import 'package:zibzo_app/core/theme/text_style_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'SFProDisplay',
    primaryColor: ColorTheme.primaryColor,
    scaffoldBackgroundColor: ColorTheme.transparentColor,
    textTheme: TextStyleTheme.lightTextTheme,
    inputDecorationTheme: inputTheme,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorTheme.lightBlueColor,
      selectedItemColor: ColorTheme.secondary,
      unselectedItemColor: ColorTheme.borderColor,
    ),
  );

  static final InputDecorationTheme inputTheme = InputDecorationTheme(
    filled: false,
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorTheme.lightGreyColor, width: 1.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: ColorTheme.lightGreyColor, width: 1.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorTheme.errorColor, width: 1.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
    outlineBorder: BorderSide(color: ColorTheme.lightGreyColor, width: 1.0),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: ColorTheme.lightGreyColor, width: 1.0),
      borderRadius: BorderRadius.circular(5.0),
    ),
    hintStyle: TextStyle(
      color: ColorTheme.successColor,
      fontSize: 16.0,
    ),
    helperStyle: TextStyle(color: ColorTheme.successColor),
    errorStyle: TextStyle(color: ColorTheme.errorColor),
  );
}
