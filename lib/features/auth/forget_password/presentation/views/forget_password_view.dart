import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/auth/forget_password/data/forget_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app_router.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _errorText;

  bool _isEmailValid(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordProvider(),
      child: Consumer<ForgetPasswordProvider>(
        builder: (context, provider, child) {
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
                    const SizedBox(height: 16),
                    Text(
                      'استعادة كلمة المرور',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: baseFont
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الرجاء إدخال البريد الالكتورني لإعادة تعيين كلمة المرور',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: baseFont
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'البريد الالكتورني',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.grey,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: Colors.grey[200],
                        errorText: _errorText,
                        errorStyle: const TextStyle(color: Colors.red,fontSize: 14, fontFamily: baseFont),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (provider.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontFamily: baseFont),
                        ),
                      ),
                    if (provider.successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          provider.successMessage!,
                          style: const TextStyle(color: Colors.green, fontFamily: baseFont),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                final email = _emailController.text.trim();
                                if (email.isEmpty) {
                                  setState(() {
                                    _errorText = 'يرجى إدخال البريد الإلكتروني';
                                  });
                                  return;
                                } else if (!_isEmailValid(email)) {
                                  setState(() {
                                    _errorText = 'يرجى إدخال بريد إلكتروني صحيح';
                                  });
                                  return;
                                }
                                setState(() {
                                  _errorText = null;
                                });
                                await provider.sendOtp(email);
                                if (provider.successMessage != null) {
                                  GoRouter.of(context).push(AppRouter.kVerificationScreen);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brownDark, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: provider.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'إعادة تعيين كلمة المرور',
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
        },
      ),
    );
  }
}
