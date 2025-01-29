import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class ProfileLogoutWidget extends StatelessWidget {
  const ProfileLogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key("LogoutKey"),
      onTap: () async {
        AnalyticsService().logLogout();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (!context.mounted) return;

        Provider.of<CartCountProvider>(context, listen: false).clearCart();

        await prefs.remove('isAuthenticated');
        if (!context.mounted) {
          return;
        }
        context.go(GoRouterPaths.loginRoute);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(28, 0, 30, 40),
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              Icons.exit_to_app_outlined,
              size: 24,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              "Log Out",
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
