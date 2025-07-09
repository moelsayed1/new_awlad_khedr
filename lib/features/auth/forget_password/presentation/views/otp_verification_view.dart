import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_router.dart';


class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40.11,
              height: 40.11,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 40.11,
                      height: 40.11,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFEBEBEB),
                        shape: OvalBorder(),
                      ),
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Back button

              const SizedBox(height: 16),
              // Title
              Text(
                'التحقق من رقم الهاتف الخاص بك',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: baseFont
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'لقد تم إرسال رسالة تحتوي على رمز تحقق، الرجاء تحقق من ذلك لاستكمال استعادة كلمة المرور',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: baseFont
                ),
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 24),
              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                      maxLength: 1,
                      decoration: InputDecoration(
                        counterText: "", // Hide character counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),

                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                   GoRouter.of(context).push(AppRouter.kUpdatePasswordScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brownDark, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'التحقق من الرمز',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Resend code text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'إعادة إرسال رمز التحقق',
                    style: TextStyle(fontSize: 14,
                      color: Colors.red,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.bold,),
                  ),
                  const SizedBox(width: 4,),
                  InkWell(
                    onTap: (){},
                    child: const Text(
                         'لم تحصل على رمز التحقق بعد؟ ',
                        style: TextStyle(fontSize: 14,
                      color: Colors.grey,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.bold,),),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
