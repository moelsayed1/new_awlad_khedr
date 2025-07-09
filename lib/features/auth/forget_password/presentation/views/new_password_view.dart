import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';



class UpdatePasswordScreen extends StatelessWidget {
  const UpdatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading:  IconButton(
            icon: const Icon(Icons.arrow_back , color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              const SizedBox(height: 16),
              // Title
              const Center(
                child: Text(
                  'قم بتعيين كلمة مرور جديدة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Center(
                child: Text(
                  'قم بإنشاء كلمة مرور جديدة، تأكد من أنه يختلف عن السابقة للأمن',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: baseFont
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              // New Password Field
              const Text(
                'كلمة المرور',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: baseFont
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                textDirection: TextDirection.rtl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'ادخل كلمة المرور الجديدة',
                  hintStyle: const TextStyle(
                    fontFamily: baseFont,
                  ),
                  hintTextDirection: TextDirection.rtl,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password Field
              const Text(
                'تأكيد كلمة المرور',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: baseFont
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                textDirection: TextDirection.rtl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'أعد إدخال كلمة المرور',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(
                    fontFamily: baseFont,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Update Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push(AppRouter.kConfirmationPage);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brownDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'تحديث كلمة المرور',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont
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
