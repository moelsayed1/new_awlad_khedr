// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/login_service.dart';
//
// class LoginProvider extends ChangeNotifier {
//   String? _token;
//   bool _isLoading = false;
//
//   final LoginService _loginService = LoginService();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//
//   String? get token => _token;
//   bool get isLoading => _isLoading;
//
//   /// Login and save token
//   Future<void> login(String userName, String password) async {
//     if (userName.isEmpty || password.isEmpty) {
//       log('Username and password are required.');
//       return;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final fetchedToken = await _loginService.login(userName, password);
//       if (fetchedToken != null) {
//         _token = fetchedToken;
//         await saveToken(fetchedToken);
//         log('Token: $_token');
//       } else {
//         log('Failed to log in. Token is null.');
//       }
//     } catch (error) {
//       log('Error during login: $error');
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Save token to secure storage
//   Future<void> saveToken(String token) async {
//     await _secureStorage.write(key: 'token', value: token);
//     log('Token securely saved: $token');
//   }
//
//   /// Load token from secure storage
//   Future<void> loadToken() async {
//     _token = await _secureStorage.read(key: 'token');
//     log('Token loaded securely: $_token');
//     notifyListeners();
//   }
//
//   /// Log out the user and clear token
//   Future<void> logout() async {
//     _token = null;
//     await _secureStorage.delete(key: 'token');
//     log('Token securely removed from storage.');
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_service.dart';
import 'dart:developer';


class LoginProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  final LoginService _loginService = LoginService();

  String? get token => _token;
  bool get isLoading => _isLoading;

  Future<void> login(String userName, String password) async {
    if (userName.isEmpty || password.isEmpty) {
      log('Username and password are required.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedToken = await _loginService.login(userName, password);
      if (fetchedToken != null) {
        _token = fetchedToken;
        await saveToken(fetchedToken);
        log('Token saved successfully: $_token');
      } else {
        log('Failed to log in. Token is null.');
        _token = null;
        await clearToken();
      }
    } catch (error) {
      log('Error during login: $error');
      _token = null;
      await clearToken();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      log('Token saved to SharedPreferences: $token');
    } catch (e) {
      log('Error saving token: $e');
    }
  }

  Future<void> loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');
      log('Token loaded from SharedPreferences: $_token');
      notifyListeners();
    } catch (e) {
      log('Error loading token: $e');
      _token = null;
    }
  }

  Future<void> clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _token = null;
      log('Token cleared from SharedPreferences');
      notifyListeners();
    } catch (e) {
      log('Error clearing token: $e');
    }
  }

  Future<void> logout() async {
    await clearToken();
    notifyListeners();
  }

  Future<bool> isLoggedIn() async {
    if (_token == null) {
      await loadToken();
    }
    return _token != null && _token!.isNotEmpty;
  }
}
