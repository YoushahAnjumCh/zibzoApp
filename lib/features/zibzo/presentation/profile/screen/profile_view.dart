import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zibzo/core/theme/app_text_styles.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_details_widget.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_items_widget.dart';
import 'package:zibzo/features/zibzo/presentation/profile/widgets/profile_logout_widget.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 54,
              ),
              ProfileDetailsWidget(),
              const SizedBox(
                height: 42,
              ),
              Column(
                children: [
                  ProfileItemsWidget(
                      icons: Icons.shopping_bag_outlined,
                      itemName: "My Orders",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.favorite_outline,
                      itemName: "Wishlist",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.location_on_outlined,
                      itemName: "Delivery Address",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.payment,
                      itemName: "Payment Methods",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.local_offer_outlined,
                      itemName: "Offers",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.notifications_none_outlined,
                      itemName: "Notifications",
                      tap: () {}),
                  ProfileItemsWidget(
                      icons: Icons.help_outline_outlined,
                      itemName: "Help",
                      tap: () {}),
                  ProfileItemsWidget(
                    icons: CupertinoIcons.exclamationmark_circle,
                    itemName: "About",
                    tap: () {},
                  ),
                  ProfileLogoutWidget(),
                  const SizedBox(
                    height: 37,
                  ),
                  Text(
                    "Privacy Policy | Terms and Conditions",
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.normal,
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
