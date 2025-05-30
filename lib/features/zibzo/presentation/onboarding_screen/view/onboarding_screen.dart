import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen image
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset(
              AssetsPath.onBoard,
              fit: BoxFit.fill, // Fills the entire screen
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  attributes: CustomTextAttributes(
                    title: StringConstant.onBoardTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomText(
                  attributes: CustomTextAttributes(
                    title: StringConstant.onBoardSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  key: const Key('get-started-button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isOnboardingShown', true);
                    if (!context.mounted) {
                      return;
                    }
                    context.push(GoRouterPaths.loginRoute);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        attributes: CustomTextAttributes(
                          title: StringConstant.onBoardButtonText,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
