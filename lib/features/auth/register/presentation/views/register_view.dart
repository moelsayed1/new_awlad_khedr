import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../../../../core/app_router.dart';
import '../../data/provider/register_provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final registrationProvider = Provider.of<RegisterProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                top: -130.h,
                right: -70.h,
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
                   SizedBox(height: 40.h),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            AssetsData.back,
                            color: Colors.black,
                          ),
                          const Text(
                            'للخلف',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                   SizedBox(height: 45.h),
                    const Text(
                      'سجل الأن',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.black,
                        fontFamily: baseFont,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                      endIndent: 10,
                      indent: 230,
                      color: Colors.black45,
                    ),
                   SizedBox(
                      height: 25.h,
                    ),
                    Text(
                      'الأسم ',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      hintText: 'السيد',
                      inputType: TextInputType.text,
                      controller: _nameController,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      'اسم المستخدم',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      hintText: 'محمد احمد',
                      inputType: TextInputType.name,
                      controller: _userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text("اضف اسم المستخدم ")),
                          );
                          return "Please enter user name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      'البريد الالكتروني',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      hintText: 'janedoe@gmail.com',
                      inputType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    Text(
                      'كلمة المرور',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      hintText: '********',
                      obscureText: passwordVisible,
                      controller: _passwordController,
                      prefixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _passwordController;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 14.h,
                    ),      
                    Text(
                      'إعادة كتابة كلمة المرور ',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontFamily: baseFont),
                    ),
                    SizedBox(
                      height: 14.h,
                    ),
                    CustomTextField(
                      hintText: '********',
                      obscureText: passwordVisible,
                      controller: _confirmPasswordController,
                      prefixIcon: IconButton(
                        icon: Icon(passwordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(
                            () {
                              passwordVisible = !passwordVisible;
                            },
                          );
                        },
                      ),
                      onChanged: (value) {
                        setState(() {
                          _passwordController;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Center(
                      child: CustomButton(
                          onTap: () {
                            if (_userNameController.text.isEmpty ||
                                _nameController.text.isEmpty ||
                                _emailController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("يجب عليك اضافة هذه الحقول!!")),
                              );
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Passwords do not match!")),
                              );
                            }else{
                              GoRouter.of(context)
                                  .push(AppRouter.kReservationPage);
                              log(
                                  'theeeeee Data Savedd${registrationProvider.saveRegisterData.toString()}');
                            }

                            registrationProvider.saveRegisterData({
                              "first_name": _nameController.text.trim(),
                              "username": _userNameController.text.trim(),
                              "email": _emailController.text.trim(),
                              "password": _passwordController.text.trim(),
                            });
                          },
                          text: 'التالي',
                          width: 200,
                          height: 60,
                          color: Colors.black,
                          textColor: Colors.white,
                          fontSize: 30),
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
