import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class ApiService {
  static const String _authTokenKey = 'token';
  static const String _tokenExpiryKey = 'token_expiry';

  String? _authToken;
  DateTime? _tokenExpiry;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString(_authTokenKey);
    final expiryMillis = prefs.getInt(_tokenExpiryKey);
    if (expiryMillis != null) {
      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMillis);
    }
  }

  Future<void> saveAuthToken(String token, {DateTime? expiry}) async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = token;
    _tokenExpiry = expiry;
    await prefs.setString(_authTokenKey, token);
    if (expiry != null) {
      await prefs.setInt(_tokenExpiryKey, expiry.millisecondsSinceEpoch);
    } else {
      await prefs.remove(_tokenExpiryKey);
    }
  }

  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = null;
    _tokenExpiry = null;
    await prefs.remove(_authTokenKey);
    await prefs.remove(_tokenExpiryKey);
  }

  bool _isTokenExpired() {
    if (_authToken == null) return true;
    if (_tokenExpiry == null) {
      return false;
    }
    return _tokenExpiry!.isBefore(DateTime.now().add(const Duration(minutes: 5)));
  }

  Future<bool> _refreshToken() async {
    try {
      // Placeholder for actual refresh token logic
      await Future.delayed(const Duration(seconds: 1));
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return await _sendRequest(() => http.get(url, headers: _buildHeaders(headers)));
  }

  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return await _sendRequest(() => http.post(url, headers: _buildHeaders(headers), body: body, encoding: encoding));
  }

  Future<http.Response> _sendRequest(Future<http.Response> Function() requestBuilder) async {
    if (_authToken == null) {
      throw Exception('Authentication required.');
    }

    if (_isTokenExpired()) {
      final refreshed = await _refreshToken();
      if (!refreshed) {
        await clearAuthToken();
        throw Exception('Session expired. Please log in again.');
      }
    }

    final response = await requestBuilder();

    if (response.statusCode == 401) {
      await clearAuthToken();
      throw Exception('Unauthorized: Token invalid or expired. Please log in.');
    }

    return response;
  }

  Future<http.Response> getOrderDetails(String orderId) async {
    final url = Uri.parse('${APIConstant.BASE_URL}/api/orders/$orderId');
    return await get(url);
  }

  Future<http.Response> getOrderInvoice(String invoiceId) async {
    final url = Uri.parse('${APIConstant.BASE_URL}${APIConstant.ORDER_INVOICE}$invoiceId');
    return await get(url);
  }

  Map<String, String> _buildHeaders(Map<String, String>? customHeaders) {
    return {
      'Authorization': 'Bearer $_authToken',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...(customHeaders ?? {}),
    };
  }

  String? get currentToken => _authToken;
} 