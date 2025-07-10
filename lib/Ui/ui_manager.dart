import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_provider.dart';
import 'home/home_provider.dart';
import 'cart/cart_provider.dart';
import 'order/order_provider.dart';
import 'product/product_provider.dart';

class UIManager {
  static final UIManager _instance = UIManager._internal();
  factory UIManager() => _instance;
  UIManager._internal();

  // Get all providers for the app
  static List<ChangeNotifierProvider> getProviders() {
    return [
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(),
      ),
      ChangeNotifierProvider<HomeProvider>(
        create: (context) => HomeProvider(),
      ),
      ChangeNotifierProvider<CartProvider>(
        create: (context) => CartProvider(),
      ),
      ChangeNotifierProvider<OrderProvider>(
        create: (context) => OrderProvider(),
      ),
      ChangeNotifierProvider<ProductProvider>(
        create: (context) => ProductProvider(),
      ),
    ];
  }

  // Initialize UI with providers
  static Widget withProviders({required Widget child}) {
    return MultiProvider(
      providers: getProviders(),
      child: child,
    );
  }

  // Get provider instances
  static AuthProvider getAuthProvider(BuildContext context) {
    return Provider.of<AuthProvider>(context, listen: false);
  }

  static HomeProvider getHomeProvider(BuildContext context) {
    return Provider.of<HomeProvider>(context, listen: false);
  }

  static CartProvider getCartProvider(BuildContext context) {
    return Provider.of<CartProvider>(context, listen: false);
  }

  static OrderProvider getOrderProvider(BuildContext context) {
    return Provider.of<OrderProvider>(context, listen: false);
  }

  static ProductProvider getProductProvider(BuildContext context) {
    return Provider.of<ProductProvider>(context, listen: false);
  }

  // Initialize app data
  static Future<void> initializeApp(BuildContext context) async {
    final authProvider = getAuthProvider(context);
    final homeProvider = getHomeProvider(context);
    final cartProvider = getCartProvider(context);

    // Load initial data
    await Future.wait([
      homeProvider.loadHomeData(),
      cartProvider.loadCart(),
    ]);
  }

  // Check authentication status
  static bool isAuthenticated(BuildContext context) {
    final authProvider = getAuthProvider(context);
    return authProvider.isAuthenticated;
  }

  // Get current user
  static dynamic getCurrentUser(BuildContext context) {
    final authProvider = getAuthProvider(context);
    return authProvider.user;
  }

  // Logout
  static void logout(BuildContext context) {
    final authProvider = getAuthProvider(context);
    final cartProvider = getCartProvider(context);

    authProvider.logout();
    cartProvider.clearCart();
  }

  // Show loading dialog
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message ?? 'جاري التحميل...'),
            ],
          ),
        );
      },
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Show error dialog
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  // Show success dialog
  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('نجح'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog
  static Future<bool> showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('تأكيد'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
