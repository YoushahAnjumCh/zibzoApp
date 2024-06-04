// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class InputTextFormFieldAttributes {
  final TextEditingController controller;
  final bool isSecureField;
  final bool autoCorrect;
  final String? hint;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validation;
  final double hintTextSize;
  final bool enable;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onPasswordVisible;
  InputTextFormFieldAttributes(
      {required this.controller,
      this.isSecureField = false,
      this.autoCorrect = false,
      this.enable = true,
      this.hint,
      this.validation,
      this.contentPadding,
      this.textInputAction,
      this.hintTextSize = 14,
      this.onFieldSubmitted,
      this.onPasswordVisible});
}
