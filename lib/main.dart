import 'package:awlad_khedr/features/auth/register/data/provider/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app_router.dart';
import 'features/auth/login/data/provider/login_provider.dart';
import 'features/drawer_slider/controller/notification_provider.dart';
import 'dart:developer';
import 'features/order/presentation/controllers/order_provider.dart';
import 'features/home/presentation/controllers/category_controller.dart';
import 'features/home/data/repositories/category_repository.dart';

String authToken = "";

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  authToken = pref.getString('token') ?? '';

  // Validate token if it exists
  if (authToken.isNotEmpty) {
    try {
      // You might want to add a token validation API call here
      // For now, we'll just check if it's not empty
      if (authToken.isEmpty) {
        await pref.remove('token');
        authToken = '';
      }
    } catch (e) {
      log('Error validating token: $e');
      await pref.remove('token');
      authToken = '';
    }
  }
}

void main() async {
  await initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) {
          final loginProvider = LoginProvider();
          loginProvider.loadToken();
          
          return loginProvider;
        }),
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CategoryController(CategoryRepository())),
      ],
      child: const AwladKhedr(),
    ),
  );
}

class AwladKhedr extends StatelessWidget {
  const AwladKhedr({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
          builder: (context, child) {
            return FutureBuilder(
              future: Future.delayed(const Duration(seconds: 0)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return child!;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        );
      },
    );
  }
}
