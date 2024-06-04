import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                return SignInScreen();
              },
            ),
            GoRoute(
              path: GoRouterPaths.signupRoute,
              builder: (BuildContext context, GoRouterState state) {
                return SignUpScreen();
              },
            ),
          ],
        );
}

class GoRouterPaths {
  static const signupRoute = "/signup";
  static const loginRoute = "/";
}
