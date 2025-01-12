// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextFormButtonAttributes {
  final VoidCallback onClick;
  final String? titleText;
  final Icon? icon;
  final Color? color;
  final double? cornerRadius;
  final EdgeInsets padding;
  final Color? titleColor;
  final Size? buttonWidthHeight;
  TextFormButtonAttributes(
      {required this.onClick,
      this.titleText,
      this.icon,
      this.color,
      this.cornerRadius,
      this.titleColor,
      this.buttonWidthHeight,
      this.padding = const EdgeInsets.symmetric(horizontal: 16)});
}
