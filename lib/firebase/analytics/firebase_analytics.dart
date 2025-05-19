import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:zibzo/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo/core/service/service_locator.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final AppLocalStorage appSecureStorage = sl<AppLocalStorage>();

//Login event
  Future<void> logLogin() async {
    await _analytics.logEvent(
      name: 'login',
    );
  }

//Signup event
  Future<void> logSignUp() async {
    await _analytics.logSignUp(
      signUpMethod: "sign_up",
    );
  }

//Logout event
  Future<void> logLogout() async {
    final userId = await appSecureStorage.getCredential("userID");
    await _analytics
        .logEvent(name: 'logout', parameters: {'userID': userId.toString()});
  }

  Future<void> logScreensView(String screenName, String screenClass) async {
    await _analytics.logScreenView(
        screenName: screenName, screenClass: screenClass);
  }

//Add to cart event
  Future<void> logAddToCart(String productID) async {
    final userId = await appSecureStorage.getCredential("userID");
    await _analytics.logAddToCart(parameters: {
      "user_id": userId.toString(),
      "product_id": productID,
    });
  }

  //Remove from cart event
  Future<void> logRemoveToCart(String productID) async {
    final userId = await appSecureStorage.getCredential("userID");
    await _analytics.logRemoveFromCart(parameters: {
      "user_id": userId.toString(),
      "product_id": productID,
    });
  }

  //Category selection event
  Future<void> logToCategory(String categoryId) async {
    final userId = await appSecureStorage.getCredential("userID");
    await _analytics.logEvent(name: 'category_selected', parameters: {
      "user_id": userId.toString(),
      "category_id": categoryId,
    });
  }
}
