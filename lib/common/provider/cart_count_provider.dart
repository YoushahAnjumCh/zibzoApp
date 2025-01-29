import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCountProvider with ChangeNotifier {
  int _cartCount = 0;
  bool _isLoaded = false;

  int get cartCount => _cartCount;
  bool get isLoaded => _isLoaded;

  Future<void> loadCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartCount = prefs.getInt('cartCount') ?? 0;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> saveCartCount(int count) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartCount');
    _cartCount = count;
    await prefs.setInt('cartCount', _cartCount);
    notifyListeners();
  }

  Future<void> deleteCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cartCount = prefs.getInt('cartCount') ?? 0;
    if (_cartCount > 0) {
      _cartCount--;
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartCount');
    _cartCount = 0;
    notifyListeners();
    await loadCartCount();
  }
}
