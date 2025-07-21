import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/app_router.dart';
import '../../data/forget_password_provider.dart';

class UpdatePasswordScreen extends StatefulWidget {
  final String otp;
  final String userEmail;
  const UpdatePasswordScreen({super.key, required this.otp, required this.userEmail});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgetPasswordProvider(),
      child: Consumer<ForgetPasswordProvider>(
        builder: (context, provider, child) {
          _isLoading = provider.isLoading;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                      controller: _passwordController,
                      textDirection: TextDirection.rtl,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
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
                      controller: _confirmPasswordController,
                      textDirection: TextDirection.rtl,
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
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
                    if (_errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _errorText!,
                          style: const TextStyle(color: Colors.red, fontFamily: baseFont),
                        ),
                      ),
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
                        onPressed: _isLoading
                            ? null
                            : () async {
                                final password = _passwordController.text.trim();
                                final confirmPassword = _confirmPasswordController.text.trim();
                                if (password.isEmpty || confirmPassword.isEmpty) {
                                  setState(() {
                                    _errorText = 'يرجى إدخال كلمة المرور وتأكيدها';
                                  });
                                  return;
                                }
                                if (password != confirmPassword) {
                                  setState(() {
                                    _errorText = 'كلمتا المرور غير متطابقتين';
                                  });
                                  return;
                                }
                                setState(() {
                                  _errorText = null;
                                });
                                final success = await provider.updatePassword(
                                  email: widget.userEmail,
                                  otp: widget.otp,
                                  password: password,
                                );
                                if (success && mounted) {
                                  GoRouter.of(context).push(AppRouter.kConfirmationPage);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brownDark,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
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
        },
      ),
    );
  }
}
