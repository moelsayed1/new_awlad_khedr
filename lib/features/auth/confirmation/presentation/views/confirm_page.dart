import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Checkmark icon
             Image.asset(AssetsData.successPng ,),
              const SizedBox(height: 20),

              // Success message text
              const Text(
                'تم ارسال بيانات للشركة سوف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: baseFont,
                  color: Colors.black,
                ),
              ),
              const Text(
                'يتم التواصل معك من احد\nممثلين الشركة',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: baseFont,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 50),

              // Done button
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).pushReplacement(AppRouter.kLoginView);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                child: const Text(
                  'تم',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
