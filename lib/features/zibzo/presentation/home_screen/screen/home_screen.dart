import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/bottom_nav_bar_notifier.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/screen/home_view.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavBarNotifier(),
      child: Consumer<BottomNavBarNotifier>(
        builder: (context, bottomNavBarNotifier, child) {
          return Scaffold(
            body: IndexedStack(
              index: bottomNavBarNotifier
                  .currentIndex, // Display widget based on current index
              children: [
                HomeView(),
                SearchView(),
                WishListView(),
                CartView(),
                ProfileView()
              ],
            ),
            bottomNavigationBar:
                const CustomBottomNavBar(), // No need to pass index, it uses notifier
          );
        },
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Search View'));
  }
}

class WishListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Wishlist View'));
  }
}

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Cart View'));
  }
}

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profile View'));
  }
}
