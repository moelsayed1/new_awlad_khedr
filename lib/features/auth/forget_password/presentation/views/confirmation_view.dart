import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';


class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: deepRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              // Success Message
              const Text(
                'تهانينا! كلمة المرور الخاصة بك لدينا\nتم تغييرها. انقر فوق متابعة لتسجيل الدخول',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: baseFont
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Continue Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   GoRouter.of(context).push(AppRouter.kLoginView);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brownDark, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'متابعة',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
