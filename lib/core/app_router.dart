import 'package:awlad_khedr/features/auth/login/presentation/views/login_view.dart';
import 'package:awlad_khedr/features/auth/register/presentation/views/register_view.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/category_view.dart';
import 'package:awlad_khedr/features/my_information/presentation/views/my_information.dart';
import 'package:awlad_khedr/features/notification/presentaion/views/notification_page.dart';
import 'package:awlad_khedr/features/home/presentation/views/home_view.dart';
import 'package:awlad_khedr/features/onboarding/presentation/views/on_boarding.dart';
import 'package:awlad_khedr/features/products_screen/presentation/views/products_screen_view.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/payment_view.dart';
import 'package:awlad_khedr/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/confirmation/presentation/views/confirm_page.dart';
import '../features/auth/forget_password/presentation/views/confirmation_view.dart';
import '../features/auth/forget_password/presentation/views/forget_password_view.dart';
import '../features/auth/forget_password/presentation/views/new_password_view.dart';
import '../features/auth/forget_password/presentation/views/otp_verification_view.dart';
import '../features/auth/ticket_reserve/presentation/views/reserve_view.dart';
import '../features/cart/presentation/views/cart_view.dart';
import '../features/drawer_slider/presentation/views/widgets/my_accounts.dart';
import '../features/most_requested/presentation/views/most_requested_views.dart';
import '../features/order/presentation/views/orders_view.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static const kOnBoarding = '/onBoarding';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kReservationPage = '/reservationPage';
  static const kSuccessScreen = '/successScreen';
  static const kHomeScreen = '/homeScreen';
  static const kMyInformation = '/myInformation';
  static const kPaymentView = '/paymentView';
  static const kMyAccounts = '/myAccounts';
  static const kNotificationPage = '/notificationScreen';
  static const kProductsScreenView = '/productsScreenView';
  static const kMostRequestedPage = '/mostRequestedPage';
  static const kCategoriesPage = '/categoriesPage';
  static const kCartViewPage = '/cartViewPage';
  static const kOrdersViewPage = '/ordersViewPage';
  static const kResetPasswordScreen = '/resetPasswordScreen';
  static const kUpdatePasswordScreen = '/updatePasswordScreen';
  static const kConfirmationPage = '/confirmationPage';
  static const kVerificationScreen = '/verificationScreen';

  static final router = GoRouter(
      initialLocation: authToken.isEmpty ? kOnBoarding : kHomeScreen,
      navigatorKey: _rootNavigatorKey, routes: [

    GoRoute(
      path: kOnBoarding,
      builder: (context, state) => const OnBoardingPage(),
    ),
    GoRoute(
      path: kLoginView,
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(

      path: kRegisterView,
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: kReservationPage,
      builder: (context, state) => const ReservationPage(),
    ),
    GoRoute(
      path: kSuccessScreen,
      builder: (context, state) => const SuccessScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: kHomeScreen,
      builder: (context, state) => const HomeScreenView(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: kPaymentView,
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        return PaymentView(
          products: args['products'],
          total: args['total'],
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: kMyInformation,
      builder: (context, state) => const MyInformation(),
    ),
    GoRoute(
      path: kMyAccounts,
      builder: (context, state) => const MyAccounts(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: kNotificationPage,
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: kProductsScreenView,
      builder: (context, state) => const ProductsScreenView(),
    ),
    GoRoute(
      path: kMostRequestedPage,
      builder: (context, state) => const MostRequestedPage(),
    ),
    GoRoute(
      path: kCategoriesPage, // <--- NEW ROUTE
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => CategoryController(CategoryRepository()),
        child: const CategoriesPage(),
      ),
    ),
    GoRoute(
      path: kCartViewPage,
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        return CartViewPage(
          products: args?['products'] ?? [],
          quantities: args?['quantities'] ?? [],
        );
      },
    ),
    GoRoute(
      path: kOrdersViewPage,
      builder: (context, state) => const OrdersViewPage(),
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
  ]);
}
