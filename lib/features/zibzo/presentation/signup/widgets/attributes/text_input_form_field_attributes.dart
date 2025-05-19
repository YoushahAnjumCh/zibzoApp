import 'package:flutter/material.dart';
import 'package:zibzo/common/password_notifier.dart';

class InputTextFormFieldAttributes {
  final TextEditingController controller;
  final bool isSecureField;
  final bool autoCorrect;
  final String? hint;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validation;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double hintTextSize;
  final InputDecoration? decoration;
  final bool enable;
  final Color? hintColor;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  void Function(String)? onChanged;
  final VoidCallback? onPasswordVisible;
  final PasswordVisibilityNotifier? passwordVisibilityNotifier;
  InputTextFormFieldAttributes(
      {required this.controller,
      this.isSecureField = false,
      this.autoCorrect = false,
      this.enable = true,
      this.hint,
      this.decoration,
      this.onChanged,
      this.validation,
      this.suffixIcon,
      this.contentPadding,
      this.textInputAction,
      this.prefixIcon,
      this.hintColor,
      this.hintTextSize = 14,
      this.passwordVisibilityNotifier,
      this.onFieldSubmitted,
      this.onPasswordVisible});
}
