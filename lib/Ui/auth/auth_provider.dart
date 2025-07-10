import 'package:flutter/material.dart';
import '../../Api/api_manager.dart';
import '../../Api/models/auth_models.dart';

class AuthProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();
  
  bool _isLoading = false;
  String? _token;
  UserData? _user;
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get token => _token;
  UserData? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null;

  // Login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.login(username, password);
      
      if (response.success && response.token != null) {
        _token = response.token;
        _user = response.user;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Login failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register({
    required String surname,
    required String first_name,
    required String email,
    required String username,
    required String password,
    required String allow_mob,
    required String mobile,
    required String address_line_1,
    required String supplier_business_name,
    String? tax_card_image,
    String? commercial_register_image,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.register(
        surname: surname,
        first_name: first_name,
        email: email,
        username: username,
        password: password,
        allow_mob: allow_mob,
        mobile: mobile,
        address_line_1: address_line_1,
        supplier_business_name: supplier_business_name,
        tax_card_image: tax_card_image,
        commercial_register_image: commercial_register_image,
      );

      if (response.success) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Registration failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Update User
  Future<bool> updateUser({
    required String first_name,
    required String email,
    required int id,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.updateUser(
        first_name: first_name,
        email: email,
        id: id,
      );

      if (response.success) {
        _user = response.data;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Update failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Send OTP
  Future<bool> sendOtp(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.sendOtp(email);

      if (response.success) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to send OTP';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Reset Password
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String password_confirmation,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.resetPassword(
        email: email,
        otp: otp,
        password: password,
        password_confirmation: password_confirmation,
      );

      if (response.success) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Password reset failed';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Send Verification Email
  Future<bool> sendVerificationEmail(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.sendVerificationEmail(email);

      if (response.success) {
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to send verification email';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Get Customer Data
  Future<bool> getCustomerData() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getCustomerData();

      if (response.success) {
        _user = response.data;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to get customer data';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Logout
  void logout() {
    _apiManager.logout();
    _token = null;
    _user = null;
    _clearError();
    notifyListeners();
  }

  // Set token (for persistence)
  void setToken(String token) {
    _token = token;
    _apiManager.setAuthToken(token);
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _errorMessage = null;
  }
} 