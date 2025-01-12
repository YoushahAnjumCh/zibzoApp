import 'package:flutter/material.dart';

class PasswordVisibilityNotifier extends ChangeNotifier {
  bool _passwordVisible = false;

  bool get passwordVisible => _passwordVisible;

  changeVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }
}
