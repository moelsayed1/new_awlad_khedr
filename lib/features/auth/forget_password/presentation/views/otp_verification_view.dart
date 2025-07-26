import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/auth/forget_password/data/forget_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app_router.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

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
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
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
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          if (index < 5) {
                            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                      },
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
                    final otp = _controllers.map((e) => e.text).join();
                    if (otp.length == 6) {
                      GoRouter.of(context).push(
                        AppRouter.kUpdatePasswordScreen,
                        extra: {'otp': otp},
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter the complete 6-digit OTP.'),
                        ),
                      );
                    }
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
