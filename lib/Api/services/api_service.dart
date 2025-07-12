import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;
  final http.Client _client = http.Client();

  // Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  // Get current auth token
  String? get authToken => _authToken;

  // Get headers with authentication
  Map<String, String> _getHeaders({bool isMultipart = false}) {
    Map<String, String> headers = isMultipart
        ? ApiConstants.multipartHeaders
        : ApiConstants.defaultHeaders;

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // GET request
  Future<http.Response> get(String endpoint) async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request with JSON body
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request with form data
  Future<http.Response> postFormData(
      String endpoint, Map<String, String> formData) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      );

      // Add headers
      request.headers.addAll(_getHeaders(isMultipart: true));

      // Add form fields
      formData.forEach((key, value) {
        request.fields[key] = value;
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // POST request with multipart form data (for file uploads)
  Future<http.Response> postMultipartFormData(
    String endpoint,
    Map<String, String> formData,
    Map<String, File>? files,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
      );

      // Add headers
      request.headers.addAll(_getHeaders(isMultipart: true));

      // Add form fields
      formData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Add files
      if (files != null) {
        files.forEach((key, file) async {
          final stream = http.ByteStream(file.openRead());
          final length = await file.length();
          final multipartFile = http.MultipartFile(
            key,
            stream,
            length,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        });
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // PUT request
  Future<http.Response> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await _client.put(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // DELETE request
  Future<http.Response> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: _getHeaders(),
      );
      return response;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Handle response and parse JSON
  Map<String, dynamic> handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw Exception('Invalid JSON response: $e');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }

  // Handle error response
  void handleErrorResponse(http.Response response) {
    if (response.statusCode >= 400) {
      try {
        final errorData = jsonDecode(response.body);
        final message = errorData['message'] ?? 'An error occurred';
        throw Exception(message);
      } catch (e) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    }
  }

  // Close the HTTP client
  void dispose() {
    _client.close();
  }
}
