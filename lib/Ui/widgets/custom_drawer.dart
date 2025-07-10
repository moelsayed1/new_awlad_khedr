import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../constant.dart';
import '../../new_core/app_router.dart';
import '../../Api/models/auth_models.dart';

class CustomDrawer extends StatelessWidget {
  final UserData? user;
  final VoidCallback? onLogout;
  final VoidCallback? onProfileTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onHomeTap;

  const CustomDrawer({
    super.key,
    this.user,
    this.onLogout,
    this.onProfileTap,
    this.onOrdersTap,
    this.onCartTap,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: const BoxDecoration(
                color: mainColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    user?.first_name ?? 'المستخدم',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Home
                  _buildMenuItem(
                    icon: Icons.home,
                    title: 'الرئيسية',
                    onTap: onHomeTap ??
                        () => GoRouter.of(context).push(AppRouter.kHomeScreen),
                  ),

                  // Profile
                  _buildMenuItem(
                    icon: Icons.person,
                    title: 'الملف الشخصي',
                    onTap: onProfileTap ??
                        () =>
                            GoRouter.of(context).push(AppRouter.kMyInformation),
                  ),

                  // Cart
                  _buildMenuItem(
                    icon: Icons.shopping_cart,
                    title: 'السلة',
                    onTap: onCartTap ??
                        () => GoRouter.of(context).push(AppRouter.kCartView),
                  ),

                  // Orders
                  _buildMenuItem(
                    icon: Icons.shopping_bag,
                    title: 'الطلبات',
                    onTap: onOrdersTap ??
                        () => GoRouter.of(context).push(AppRouter.kOrdersView),
                  ),

                  // Categories
                  _buildMenuItem(
                    icon: Icons.category,
                    title: 'الأصناف',
                    onTap: () =>
                        GoRouter.of(context).push(AppRouter.kCategoriesPage),
                  ),

                  // Most Requested
                  _buildMenuItem(
                    icon: Icons.star,
                    title: 'الأكثر طلباً',
                    onTap: () =>
                        GoRouter.of(context).push(AppRouter.kMostRequestedPage),
                  ),

                  // Products
                  _buildMenuItem(
                    icon: Icons.inventory,
                    title: 'المنتجات',
                    onTap: () => GoRouter.of(context)
                        .push(AppRouter.kProductsScreenView),
                  ),

                  const Divider(),

                  // Settings
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'الإعدادات',
                    onTap: () {
                      // Navigate to settings
                    },
                  ),

                  // Help
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'المساعدة',
                    onTap: () {
                      // Navigate to help
                    },
                  ),

                  const Divider(),

                  // Logout
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'تسجيل الخروج',
                    onTap: onLogout ??
                        () {
                          // Show logout confirmation
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('تسجيل الخروج'),
                              content:
                                  const Text('هل أنت متأكد من تسجيل الخروج؟'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    onLogout?.call();
                                  },
                                  child: const Text('تأكيد'),
                                ),
                              ],
                            ),
                          );
                        },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
        size: 24.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.sp,
          fontFamily: baseFont,
        ),
      ),
      onTap: onTap,
    );
  }
}
