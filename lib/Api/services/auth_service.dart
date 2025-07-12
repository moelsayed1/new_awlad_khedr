import 'dart:io';
import 'dart:developer';
import '../api_constants.dart';
import '../models/auth_models.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  // Login
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      log('Login request data: ${request.toFormData()}');
      log('Login endpoint: ${ApiConstants.baseUrl}${ApiConstants.login}');

      final response = await _apiService.postFormData(
        ApiConstants.login,
        request.toFormData(),
      );

      log('Login response status: ${response.statusCode}');
      log('Login response body: ${response.body}');

      final responseData = _apiService.handleResponse(response);
      final loginResponse = LoginResponse.fromJson(responseData);

      log('Parsed login response: success=${loginResponse.success}, message=${loginResponse.message}');

      // Set auth token if login is successful
      if (loginResponse.success && loginResponse.token != null) {
        _apiService.setAuthToken(loginResponse.token!);
      }

      return loginResponse;
    } catch (e) {
      log('Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Register
  Future<ApiResponse<UserData>> register(RegisterRequest request) async {
    try {
      Map<String, String> formData = request.toFormData();
      Map<String, File>? files;

      // Handle file uploads if present
      if (request.tax_card_image != null ||
          request.commercial_register_image != null) {
        files = {};
        if (request.tax_card_image != null) {
          files['tax_card_image'] = File(request.tax_card_image!);
        }
        if (request.commercial_register_image != null) {
          files['commercial_register_image'] =
              File(request.commercial_register_image!);
        }
      }

      final response = files != null
          ? await _apiService.postMultipartFormData(
              ApiConstants.register,
              formData,
              files,
            )
          : await _apiService.postFormData(
              ApiConstants.register,
              formData,
            );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, UserData.fromJson);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Update User
  Future<ApiResponse<UserData>> updateUser(UpdateUserRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.updateUser,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, UserData.fromJson);
    } catch (e) {
      throw Exception('Update user failed: $e');
    }
  }

  // Send OTP
  Future<ApiResponse<dynamic>> sendOtp(SendOtpRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.sendOtp,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Send OTP failed: $e');
    }
  }

  // Reset Password
  Future<ApiResponse<dynamic>> resetPassword(
      ResetPasswordRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.resetPassword,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Reset password failed: $e');
    }
  }

  // Send Verification Email
  Future<ApiResponse<dynamic>> sendVerificationEmail(
      SendVerificationEmailRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.sendVerificationEmail,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Send verification email failed: $e');
    }
  }

  // Get Customer Data
  Future<ApiResponse<UserData>> getCustomerData() async {
    try {
      final response = await _apiService.get(ApiConstants.customerData);
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, UserData.fromJson);
    } catch (e) {
      throw Exception('Get customer data failed: $e');
    }
  }

  // Logout
  void logout() {
    _apiService.clearAuthToken();
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _apiService.authToken != null;
  }

  // Get current auth token
  String? getAuthToken() {
    return _apiService.authToken;
  }
}
