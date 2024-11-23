import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zibzo_app/common/bottom_nav_bar_notifier.dart'; // Ensure you have provider in your pubspec.yaml

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavBarNotifier = Provider.of<BottomNavBarNotifier>(context);

    return BottomNavigationBar(
      iconSize: 30,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: bottomNavBarNotifier.currentIndex,
      onTap: (index) {
        bottomNavBarNotifier.updateIndex(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite_border,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.shopping_bag_outlined),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outlined,
          ),
          label: '',
        ),
      ],
    );
  }
}
