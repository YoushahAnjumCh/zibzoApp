import 'package:flutter/material.dart';
import 'package:zibzo_app/common/password_notifier.dart';

class InputTextFormFieldAttributes {
  final TextEditingController controller;
  final bool isSecureField;
  final bool autoCorrect;
  final String? hint;
  final EdgeInsets? contentPadding;
  final String? Function(String?)? validation;
  final Widget? prefixIcon;
  final double hintTextSize;
  final bool enable;
  final Color? hintColor;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onPasswordVisible;
  final PasswordVisibilityNotifier? passwordVisibilityNotifier;
  InputTextFormFieldAttributes(
      {required this.controller,
      this.isSecureField = false,
      this.autoCorrect = false,
      this.enable = true,
      this.hint,
      this.validation,
      this.contentPadding,
      this.textInputAction,
      this.prefixIcon,
      this.hintColor,
      this.hintTextSize = 14,
      this.passwordVisibilityNotifier,
      this.onFieldSubmitted,
      this.onPasswordVisible});
}
