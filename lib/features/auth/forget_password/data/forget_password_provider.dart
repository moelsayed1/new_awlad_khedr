import 'dart:convert';

import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> sendOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
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
}
