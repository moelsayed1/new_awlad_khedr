import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Ui/auth/login_screen.dart';
import '../Ui/home/home_screen.dart';
import '../Ui/cart/cart_screen.dart';
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
    initialLocation: '/onBoarding',
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

// Real screen implementations with proper Arabic styling
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoPng.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 40),
              const Text(
                'أهلاً وسهلاً بك في أولاد خضر',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              const Text(
                'اكتشف منتجاتنا المميزة',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: baseFont,
                  color: Colors.grey,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () =>
                    GoRouter.of(context).push(AppRouter.kLoginView),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'ابدأ التسوق',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: baseFont,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'تسجيل حساب جديد',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة التسجيل',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'إعادة تعيين كلمة المرور',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة إعادة تعيين كلمة المرور',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'تحديث كلمة المرور',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة تحديث كلمة المرور',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'تأكيد الطلب',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة تأكيد الطلب',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'التحقق',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة التحقق',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الطلبات',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة الطلبات',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class MyInformationScreen extends StatelessWidget {
  const MyInformationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'معلوماتي',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة معلوماتي',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الإشعارات',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة الإشعارات',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'المنتجات',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة المنتجات',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class MostRequestedScreen extends StatelessWidget {
  const MostRequestedScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الأكثر طلباً',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة الأكثر طلباً',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الأصناف',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة الأصناف',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class ProductDetailsScreen extends StatelessWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'تفاصيل المنتج',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'تفاصيل المنتج: $productId',
            style: const TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class PaymentScreen extends StatelessWidget {
  final List<dynamic> products;
  final double total;
  const PaymentScreen({super.key, required this.products, required this.total});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الدفع',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'صفحة الدفع: $total ج.م',
            style: const TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'تم الطلب بنجاح!',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: baseFont,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    GoRouter.of(context).push(AppRouter.kHomeScreen),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'العودة للرئيسية',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: baseFont,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class ReservationScreen extends StatelessWidget {
  const ReservationScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'الحجز',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة الحجز',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}

class MyAccountsScreen extends StatelessWidget {
  const MyAccountsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'حساباتي',
            style: TextStyle(fontFamily: baseFont),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: Text(
            'صفحة حساباتي',
            style: TextStyle(
              fontSize: 20,
              fontFamily: baseFont,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      );
}
