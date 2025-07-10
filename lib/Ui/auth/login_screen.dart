import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constant.dart';
import '../../new_core/custom_button.dart';
import '../../new_core/custom_text_field.dart';
import '../../new_core/app_router.dart';
import 'auth_provider.dart';
import 'dart:developer';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130,
                right: -70,
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: mainColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 100),
                    const SizedBox(height: 30),
                    const Text(
                      'مرحباً بك\nقم بتسجيل دخولك',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 38,
                        color: Colors.black,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      endIndent: 121,
                      indent: 121,
                      color: Colors.black45,
                    ),
                    const SizedBox(height: 42),
                    CustomTextField(
                      hintText: 'اسم المستخدم ',
                      inputType: TextInputType.emailAddress,
                      controller: _userNameController,
                    ),
                    const SizedBox(height: 36),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: passwordVisible,
                    ),
                    // CustomTextField(
                    //   hintText: 'كلمة المرور',
                    //   controller: _passwordController,
                    //   obscureText: passwordVisible,
                    //   inputType: TextInputType.number,
                    //   prefixIcon: IconButton(
                    //     icon: Icon(
                    //       passwordVisible
                    //           ? Icons.visibility_off
                    //           : Icons.visibility,
                    //     ),
                    //     onPressed: () {
                    //       setState(() {
                    //         passwordVisible = !passwordVisible;
                    //       });
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context)
                                .push(AppRouter.kResetPasswordScreen);
                          },
                          child: const Text(
                            'نسيت كلمة السر',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: baseFont,
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    authProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            onTap: () async {
                              log("Username: ${_userNameController.text}");
                              log("Password: ${_passwordController.text}");

                              // if (_userNameController.text.isEmpty ||
                              //     _passwordController.text.isEmpty) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text(
                              //           'Username and password are required.'),
                              //     ),
                              //   );
                              //   return;
                              // }

                              final success = await authProvider.login(
                                "Abdelaziz",
                                "12345",
                              );

                              if (success) {
                                log("Login successful: ${authProvider.token}");
                                GoRouter.of(context)
                                    .push(AppRouter.kHomeScreen);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage ??
                                        'Login failed. Please try again.'),
                                  ),
                                );
                              }
                            },
                            text: 'دخول',
                            width: double.infinity,
                            height: 64,
                            color: Colors.black,
                            textColor: Colors.white,
                            fontSize: 30,
                          ),
                    const SizedBox(height: 18),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kRegisterView);
                      },
                      child: const Center(
                        child: Text(
                          'تسجيل حساب جديد',
                          style: TextStyle(
                            fontFamily: baseFont,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
