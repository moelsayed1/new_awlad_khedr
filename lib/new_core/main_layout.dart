import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../constant.dart';
import '../ui/cart/cart_provider.dart';
import 'app_router.dart';

class MainLayout extends StatelessWidget {
  final int selectedIndex;
  final Widget child;
  final bool showBottomNavigation;

  const MainLayout({
    super.key,
    required this.selectedIndex,
    required this.child,
    this.showBottomNavigation = true,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRouter.kHomeScreen);
        break;
      case 1:
        context.go(AppRouter.kCartView);
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
      bottomNavigationBar: showBottomNavigation ? _buildBottomNavigationBar(context) : null,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: darkOrange,
          unselectedItemColor: Colors.black,
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(context, index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  Icon(selectedIndex == 1 ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                  if (cartProvider.cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${cartProvider.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'السلة',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 2 ? Icons.notifications_active : Icons.notifications_active_outlined),
              label: 'التنبيهات',
            ),
            BottomNavigationBarItem(
              icon: Icon(selectedIndex == 3 ? Icons.person : Icons.person_outline),
              label: 'الملف الشخصي',
            ),
          ],
        );
      },
    );
  }
} 