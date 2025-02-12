import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/bottom_nav_bar_notifier.dart';
import 'package:zibzo/core/service/service_locator.dart';
import 'package:zibzo/features/zibzo/presentation/cart/bloc/bloc/cart_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/cart/view/cart_screen.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/screen/home_view.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/bottom_navigation_bar.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/custom_bottom_sheet.dart';
import 'package:zibzo/features/zibzo/presentation/profile/screen/profile_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavBarNotifier(),
      child: Consumer<BottomNavBarNotifier>(
        builder: (context, bottomNavBarNotifier, child) {
          return BlocProvider<CartBloc>(
            create: (context) => sl<CartBloc>(),
            child: PopScope(
              canPop: false,
              onPopInvoked: (didPop) {
                if (didPop) return;
                CustomBottomSheet.show(
                  context: context,
                  onConfirm: () => Navigator.of(context).pop(true),
                );
              },
              child: Scaffold(
                body: IndexedStack(
                  index: bottomNavBarNotifier.currentIndex,
                  children: const [
                    HomeView(),
                    WishListView(),
                    CartScreen(),
                    ProfileView(),
                  ],
                ),
                bottomNavigationBar: const CustomBottomNavBar(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WishListView extends StatelessWidget {
  const WishListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Wishlist View'));
  }
}
