import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo_app/core/secure_storage/app_secure_storage.dart';
import 'package:zibzo_app/core/service/service_locator.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/screen/home_screen.dart';
import 'package:zibzo_app/features/zibzo/presentation/signin/screen/sign_in_screen.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/pages/signup_view.dart';

class AppRouter {
  final GoRouter router;

  AppRouter()
      : router = GoRouter(
          routes: [
            GoRoute(
              path: GoRouterPaths.loginRoute,
              builder: (BuildContext context, GoRouterState state) {
                final AppLocalStorage appSharedPrefStorage =
                    sl<AppLocalStorage>(instanceName: 'sharedPreferences');
                final email = appSharedPrefStorage.readFromStorage('email');
                if (email != null) {
                  return HomeScreen();
                } else {
                  return SignInScreen();
                }
              },
            ),
            GoRoute(
              path: GoRouterPaths.signupRoute,
              builder: (BuildContext context, GoRouterState state) {
                return SignUpScreen();
              },
            ),
            GoRoute(
              path: GoRouterPaths.homeScreenRoute,
              builder: (BuildContext context, GoRouterState state) {
                return HomeScreen();
              },
            ),
          ],
        );
}

class GoRouterPaths {
  static const signupRoute = "/signup";
  static const loginRoute = "/";
  static const homeScreenRoute = "/homescreen";
}
