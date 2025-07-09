import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/app_router.dart';
import '../../data/provider/login_provider.dart';
import 'dart:developer';


class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130, // Adjust this to move the circle up/down
                right: -70, // Adjust this to move the circle left/right
                child: Container(
                  width: 350,
                  height: 350,
                  decoration: const BoxDecoration(
                    color: mainColor, // Your yellow color
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 100), // Space at the top
                    // InkWell(
                    //   onTap: () {
                    //     GoRouter.of(context).pop();
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Image.asset(
                    //         AssetsData.back,
                    //         color: Colors.black,
                    //       ),
                    //       const Text(
                    //         'للخلف',
                    //         style: TextStyle(
                    //             fontSize: 18,
                    //             color: Colors.black,
                    //             fontFamily: baseFont,
                    //             fontWeight: FontWeight.w500),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                    const SizedBox(
                      height: 42,
                    ),
                    CustomTextField(
                      hintText: 'اسم المستخدم ',
                      inputType: TextInputType.emailAddress,
                      controller: _userNameController,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    CustomTextField(
                      hintText: 'كلمة المرور',
                      controller: _passwordController,
                      obscureText: passwordVisible,
                      prefixIcon: IconButton(
                        icon: Icon(
                          passwordVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            GoRouter.of(context).push(AppRouter.kResetPasswordScreen);
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
                    const SizedBox(
                      height: 38,
                    ),
                    loginProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        :   loginProvider.isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                        onTap: () async {
                          log("Username: ${_userNameController.text}");
                          log("Password: ${_passwordController.text}");

                          if (_userNameController.text.isEmpty ||
                              _passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Username and password are required.'),
                              ),
                            );
                            return;
                          }
                          await loginProvider.login(
                            _userNameController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (loginProvider.token != null) {
                            log("Login successful: ${loginProvider.token}");
                            GoRouter.of(context).push(AppRouter.kHomeScreen);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login failed. Please try again.'),
                              ),
                            );
                          }
                        },
                        text: 'دخول',
                        width: double.infinity,
                        height: 64,
                        color: Colors.black,
                        textColor: Colors.white,
                        fontSize: 30
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(AppRouter.kRegisterView);
                      },
                      child:Center(
                        child: const Text(
                          'تسجيل حساب جديد',
                          style: TextStyle(
                              fontFamily: baseFont,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
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
