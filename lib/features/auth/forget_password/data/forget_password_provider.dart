import 'dart:convert';
import 'dart:developer';

import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String? userEmail;
  String? otpCode;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> sendOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    userEmail = email;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(APIConstant.SEND_OTP),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        _successMessage = 'تم إرسال رمز التحقق إلى بريدك الإلكتروني';
      } else {
        _errorMessage = 'فشل في إرسال رمز التحقق. حاول مرة أخرى.';
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء الاتصال بالخادم.';
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updatePassword({required String email, required String otp, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse(APIConstant.RESET_PASSWORD),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': password,
        },
      );
      print('Reset password response: \n${response.body}'); // Debug print
      if (response.statusCode == 200) {
        _successMessage = 'تم تحديث كلمة المرور بنجاح';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        try {
          final responseData = jsonDecode(response.body);
          if (responseData['message'] != null) {
            _errorMessage = responseData['message'];
          } else {
            _errorMessage = 'فشل في تحديث كلمة المرور. حاول مرة أخرى.';
          }
        } catch (e) {
          _errorMessage = 'فشل في تحديث كلمة المرور. حاول مرة أخرى.';
        }
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء الاتصال بالخادم.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
