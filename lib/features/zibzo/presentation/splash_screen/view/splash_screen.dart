import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/routes/app_routes.dart'; // Update this import path if necessary

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final isOnboardingShown = prefs.getBool('isOnboardingShown') ?? false;
      final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      if (!mounted) return;

      if (!isOnboardingShown) {
        context.go(GoRouterPaths.onboardingRoute);
      } else if (isAuthenticated) {
        context.go(GoRouterPaths.homeScreenRoute);
      } else {
        context.go(GoRouterPaths.loginRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AssetsPath.splash,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
