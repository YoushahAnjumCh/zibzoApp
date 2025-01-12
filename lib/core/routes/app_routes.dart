import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/view/cart_screen.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/screen/category_products_view.dart';

import 'package:zibzo/features/zibzo/presentation/home_screen/screen/home_screen.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';
import 'package:zibzo/features/zibzo/presentation/signin/screen/sign_in_screen.dart';
import 'package:zibzo/features/zibzo/presentation/signup/screen/sign_up_screen.dart';

class AppRouter {
  AppRouter();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  late final GoRouter router = GoRouter(
    observers: [observer],
    routes: [
      GoRoute(
        path: GoRouterPaths.loginRoute,
        builder: (context, state) {
          return BlocBuilder<SharedPreferencesCubit, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return HomeScreen();
              } else if (state is Unauthenticated) {
                return SignInScreen();
              } else {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
            },
          );
        },
      ),
      GoRoute(
        path: GoRouterPaths.homeScreenRoute,
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen();
        },
      ),
      GoRoute(
        path: GoRouterPaths.signupRoute,
        builder: (BuildContext context, GoRouterState state) {
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: GoRouterPaths.loginRoute,
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen();
        },
      ),
      GoRoute(
        path: GoRouterPaths.cartScreenRoute,
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider(
            create: (_) => sl<CartBloc>()..add(GetCartEvent()),
            child: CartScreen(),
          );
        },
      ),
      GoRoute(
        path: GoRouterPaths.categoryProducts,
        name: 'categoryProducts',
        builder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return BlocProvider(
            create: (_) => sl<CategoryProductBloc>()
              ..add(CategoryProductEvent(categoryName: categoryName)),
            child: CategoryProductsView(categoryName: categoryName),
          );
        },
      ),
    ],
  );
}

class GoRouterPaths {
  static const signupRoute = "/signup";
  static const loginRoute = "/";
  static const homeScreenRoute = "/homescreen";
  static const cartScreenRoute = "/cartscreen";
  static const categoryProducts = "/categoryproducts/:categoryName";
}
