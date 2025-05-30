import 'package:flutter/material.dart';

class CustomTextAttributes {
  final String title;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const CustomTextAttributes({
    required this.title,
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign,
    this.padding,
  });
}
