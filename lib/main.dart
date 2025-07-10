import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_core/app_router.dart';
import 'new_core/service_locator.dart';
import 'Ui/ui_manager.dart';
import 'dart:developer';

String authToken = "";

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  ServiceLocator.setup();

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
        await pref.clear();
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
        // UI Providers
        ChangeNotifierProvider(create: (_) => ServiceLocator.authProvider),
        ChangeNotifierProvider(create: (_) => ServiceLocator.homeProvider),
        ChangeNotifierProvider(create: (_) => ServiceLocator.cartProvider),
        ChangeNotifierProvider(create: (_) => ServiceLocator.orderProvider),
        ChangeNotifierProvider(create: (_) => ServiceLocator.productProvider),
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
