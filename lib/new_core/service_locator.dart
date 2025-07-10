import '../Api/api_manager.dart';
import '../Api/services/auth_service.dart';
import '../Api/services/product_service.dart';
import '../Api/services/cart_service.dart';
import '../Api/services/order_service.dart';
import '../ui/auth/auth_provider.dart';
import '../ui/home/home_provider.dart';
import '../ui/cart/cart_provider.dart';
import '../ui/order/order_provider.dart';
import '../ui/product/product_provider.dart';
import '../ui/ui_manager.dart';

import 'package:get_it/get_it.dart';

final GetIt serviceLocator = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // API Services
    serviceLocator.registerLazySingleton<ApiManager>(() => ApiManager());
    serviceLocator.registerLazySingleton<AuthService>(() => AuthService());
    serviceLocator.registerLazySingleton<ProductService>(() => ProductService());
    serviceLocator.registerLazySingleton<CartService>(() => CartService());
    serviceLocator.registerLazySingleton<OrderService>(() => OrderService());

    // UI Providers
    serviceLocator.registerLazySingleton<AuthProvider>(() => AuthProvider());
    serviceLocator.registerLazySingleton<HomeProvider>(() => HomeProvider());
    serviceLocator.registerLazySingleton<CartProvider>(() => CartProvider());
    serviceLocator.registerLazySingleton<OrderProvider>(() => OrderProvider());
    serviceLocator.registerLazySingleton<ProductProvider>(() => ProductProvider());
    serviceLocator.registerLazySingleton<UIManager>(() => UIManager());
  }

  static void reset() {
    serviceLocator.reset();
  }

  // API Services Getters
  static ApiManager get apiManager => serviceLocator<ApiManager>();
  static AuthService get authService => serviceLocator<AuthService>();
  static ProductService get productService => serviceLocator<ProductService>();
  static CartService get cartService => serviceLocator<CartService>();
  static OrderService get orderService => serviceLocator<OrderService>();

  // UI Providers Getters
  static AuthProvider get authProvider => serviceLocator<AuthProvider>();
  static HomeProvider get homeProvider => serviceLocator<HomeProvider>();
  static CartProvider get cartProvider => serviceLocator<CartProvider>();
  static OrderProvider get orderProvider => serviceLocator<OrderProvider>();
  static ProductProvider get productProvider => serviceLocator<ProductProvider>();
  static UIManager get uiManager => serviceLocator<UIManager>();
} 