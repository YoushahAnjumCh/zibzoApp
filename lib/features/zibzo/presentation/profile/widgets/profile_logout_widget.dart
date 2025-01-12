import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/shared_preferences/cubit/shared_preferences_state.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class ProfileLogoutWidget extends StatelessWidget {
  const ProfileLogoutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedPreferencesCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          key: Key("LogoutKey"),
          onTap: () {
            AnalyticsService().logLogout();
            context.read<SharedPreferencesCubit>().logout("token");
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
      },
    );
  }
}
