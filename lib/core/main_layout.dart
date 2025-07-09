import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

class MainLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget child;

  const MainLayout({super.key, required this.selectedIndex, required this.child});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.kHomeScreen);
        break;
      case 1:
        context.go(AppRouter.kCartViewPage);
        break;
      case 2:
        context.go(AppRouter.kNotificationPage);
        break;
      case 3:
        context.go(AppRouter.kMyInformation);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor:  darkOrange,
          unselectedItemColor: Colors.black,
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
          items:  [
            BottomNavigationBarItem(
              icon: Icon(selectedIndex  == 0 ? Icons.home : Icons.home_outlined ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 2 ? Icons.notifications_active : Icons.notifications_active_outlined),
              label: 'Alert',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 4 ? Icons.person : Icons.person_outline
              ),
              label: 'Person',
            ),
          ],
        )
    );
  }
}