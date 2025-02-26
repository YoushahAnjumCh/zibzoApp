import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/view/cart_screen.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/bloc/bloc/category_product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/screen/category_products_view.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/screen/home_screen.dart';
import 'package:zibzo/features/zibzo/presentation/offers_list_view/view/offers_list_view.dart';
import 'package:zibzo/features/zibzo/presentation/onboarding_screen/view/onboarding_screen.dart';
import 'package:zibzo/features/zibzo/presentation/search/pages/search_view.dart';
import 'package:zibzo/features/zibzo/presentation/signin/screen/sign_in_screen.dart';
import 'package:zibzo/features/zibzo/presentation/signup/screen/sign_up_screen.dart';
import 'package:zibzo/features/zibzo/presentation/splash_screen/view/splash_screen.dart';

class AppRouter {
  AppRouter();
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  late final GoRouter router = GoRouter(
    initialLocation: GoRouterPaths.splashRoute,
    observers: [observer],
    routes: [
      GoRoute(
        path: GoRouterPaths.loginRoute,
        builder: (context, state) => SignInScreen(),
      ),
      GoRoute(
        path: GoRouterPaths.offerListViewRoute,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          final product = extra['product'] as HomeResponseEntity;
          final productState = extra['state'] as ProductState;

          return CustomTransitionPage(
            key: state.pageKey,
            child: OffersListView(
              product: product,
              productState: productState,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
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
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: SignUpScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.2,
                    end: 1.0,
                  ).animate(animation),
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 1.0,
                      end: 0.8,
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: GoRouterPaths.onboardingRoute,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: GoRouterPaths.searchViewRoute,
        builder: (context, state) => SearchView(),
      ),
      GoRoute(
        path: GoRouterPaths.splashRoute,
        builder: (context, state) => SplashScreen(),
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
        pageBuilder: (context, state) {
          final categoryName = state.pathParameters['categoryName']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BlocProvider(
              create: (_) => sl<CategoryProductBloc>()
                ..add(CategoryProductEvent(categoryName: categoryName)),
              child: CategoryProductsView(categoryName: categoryName),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}

class GoRouterPaths {
  static const onboardingRoute = "/onboarding";
  static const splashRoute = "/";
  static const signupRoute = "/signup";
  static const loginRoute = "/login";
  static const offerListViewRoute = "/offerslistview";
  static const searchViewRoute = "/searchview";
  static const homeScreenRoute = "/homescreen";
  static const cartScreenRoute = "/cartscreen";
  static const categoryProducts = "/categoryproducts/:categoryName";
}
