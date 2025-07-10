import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../Ui/auth/login_screen.dart';
import '../Ui/home/home_screen.dart';
import '../Ui/cart/cart_screen.dart';
import '../Ui/auth/auth_provider.dart';
import '../Ui/home/home_provider.dart';
import '../Ui/cart/cart_provider.dart';
import '../Ui/order/order_provider.dart';
import '../Ui/product/product_provider.dart';
import '../Ui/ui_manager.dart';
import '../constant.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  // Authentication Routes
  static const kOnBoarding = '/onBoarding';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kResetPasswordScreen = '/resetPasswordScreen';
  static const kUpdatePasswordScreen = '/updatePasswordScreen';
  static const kConfirmationPage = '/confirmationPage';
  static const kVerificationScreen = '/verificationScreen';

  // Main App Routes
  static const kHomeScreen = '/homeScreen';
  static const kCartView = '/cartView';
  static const kOrdersView = '/ordersView';
  static const kMyInformation = '/myInformation';
  static const kNotificationPage = '/notificationScreen';

  // Product Routes
  static const kProductsScreenView = '/productsScreenView';
  static const kMostRequestedPage = '/mostRequestedPage';
  static const kCategoriesPage = '/categoriesPage';
  static const kProductDetails = '/productDetails';

  // Payment Routes
  static const kPaymentView = '/paymentView';
  static const kSuccessScreen = '/successScreen';

  // Other Routes
  static const kReservationPage = '/reservationPage';
  static const kMyAccounts = '/myAccounts';

  static final router = GoRouter(
    initialLocation: '/onBoarding', // Using default route instead of authToken
    navigatorKey: _rootNavigatorKey,
    routes: [
      // Onboarding
      GoRoute(
        path: kOnBoarding,
        builder: (context, state) => const OnBoardingPage(),
      ),

      // Authentication Routes
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: kResetPasswordScreen,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: kUpdatePasswordScreen,
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: kConfirmationPage,
        builder: (context, state) => const ConfirmationPage(),
      ),
      GoRoute(
        path: kVerificationScreen,
        builder: (context, state) => const VerificationScreen(),
      ),

      // Main App Routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kHomeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kCartView,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kOrdersView,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kMyInformation,
        builder: (context, state) => const MyInformationScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kNotificationPage,
        builder: (context, state) => const NotificationScreen(),
      ),

      // Product Routes
      GoRoute(
        path: kProductsScreenView,
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: kMostRequestedPage,
        builder: (context, state) => const MostRequestedScreen(),
      ),
      GoRoute(
        path: kCategoriesPage,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: kProductDetails,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>?;
          return ProductDetailsScreen(
            productId: args?['productId'] ?? 0,
          );
        },
      ),

      // Payment Routes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: kPaymentView,
        builder: (context, state) {
          final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            products: args['products'],
            total: args['total'],
          );
        },
      ),
      GoRoute(
        path: kSuccessScreen,
        builder: (context, state) => const SuccessScreen(),
      ),

      // Other Routes
      GoRoute(
        path: kReservationPage,
        builder: (context, state) => const ReservationScreen(),
      ),
      GoRoute(
        path: kMyAccounts,
        builder: (context, state) => const MyAccountsScreen(),
      ),
    ],
  );
}

// Placeholder screens - these should be implemented based on your needs
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Onboarding')));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Register')));
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Reset Password')));
}

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Update Password')));
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Confirmation')));
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Verification')));
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Orders')));
}

class MyInformationScreen extends StatelessWidget {
  const MyInformationScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('My Information')));
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Notifications')));
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Products')));
}

class MostRequestedScreen extends StatelessWidget {
  const MostRequestedScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Most Requested')));
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Categories')));
}

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Product Details: $productId')));
}

class PaymentScreen extends StatelessWidget {
  final List<dynamic> products;
  final double total;
  const PaymentScreen({super.key, required this.products, required this.total});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Payment: $total')));
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Success')));
}

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Reservation')));
}

class MyAccountsScreen extends StatelessWidget {
  const MyAccountsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('My Accounts')));
}
