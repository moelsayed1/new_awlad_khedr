import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../constant.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerInfo {
  final int userId;
  final String? phone;
  final String name;
  final String supplierBusinessName;
  final String addressLine1;
  final String email;
  final String? profilePhoto;

  CustomerInfo({
    required this.userId,
    required this.phone,
    required this.name,
    required this.supplierBusinessName,
    required this.addressLine1,
    required this.email,
    this.profilePhoto,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      userId: json['user_id'],
      phone: json['mobile'],
      name: json['name'],
      supplierBusinessName: json['supplier_business_name'],
      addressLine1: json['address_line_1'],
      email: json['email'],
      profilePhoto: json['profile_photo'],
    );
  }
}

class MyInformationLogic {
  static Future<CustomerInfo?> fetchCustomerInfo(String token) async {
    final response = await http.get(
      Uri.parse(APIConstant.GET_CUSTOMER_MAIN_DATA),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    
    // Debug the response
    log('Fetch customer info response status: ${response.statusCode}');
    log('Fetch customer info response body: ${response.body}');
    
    if (response.statusCode == 200) {
      try {
        final dynamic responseData = json.decode(response.body);
        
        // Handle both array and object responses
        if (responseData is List) {
          if (responseData.isNotEmpty) {
            return CustomerInfo.fromJson(responseData[0]);
          }
        } else if (responseData is Map<String, dynamic>) {
          // If the response is an object with data structure similar to update response
          if (responseData['data'] != null) {
            final Map<String, dynamic> data = responseData['data'];
            final Map<String, dynamic> contact = data['contact'] ?? {};
            final Map<String, dynamic> user = data['user'] ?? {};
            
            return CustomerInfo(
              userId: 0,
              phone: contact['mobile'],
              name: contact['first_name'] ?? user['first_name'] ?? '',
              supplierBusinessName: contact['supplier_business_name'] ?? '',
              addressLine1: contact['address_line_1'] ?? '',
              email: contact['email'] ?? user['email'] ?? '',
              profilePhoto: data['profile_photo'],
            );
          } else {
            // Direct object response
            return CustomerInfo.fromJson(responseData);
          }
        }
      } catch (e) {
        log('Error parsing fetch customer info response: $e');
      }
    }
    return null;
  }

  static Future<bool> updateCustomerInfo(String token, {
    required String name,
    required String? phone,
    required String email,
    required String addressLine1,
    required String supplierBusinessName,
  }) async {
    final response = await http.post(
      Uri.parse(APIConstant.GET_CUSTOMER_MAIN_DATA),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'address_line_1': addressLine1,
        'supplier_business_name': supplierBusinessName,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<CustomerInfo?> updateUserDataWithPhoto(
    String token, {
    required String name,
    required String? phone,
    required String email,
    required String addressLine1,
    required String supplierBusinessName,
    File? profilePhoto,
  }) async {
    var uri = Uri.parse(APIConstant.UPDATE_USER_DATA);
    var request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['first_name'] = name;
    request.fields['email'] = email;
    request.fields['mobile'] = phone ?? '';
    request.fields['supplier_business_name'] = supplierBusinessName;
    request.fields['address_line_1'] = addressLine1;
    if (profilePhoto != null) {
      request.files.add(await http.MultipartFile.fromPath('profile_photo', profilePhoto.path));
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Debugging output
    log('Status code: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success' && responseData['data'] != null) {
          final Map<String, dynamic> data = responseData['data'];
          final Map<String, dynamic> contact = data['contact'] ?? {};
          final Map<String, dynamic> user = data['user'] ?? {};
          
          // Create CustomerInfo from the update response
          return CustomerInfo(
            userId: 0, // We don't have user_id in this response
            phone: contact['mobile'],
            name: contact['first_name'] ?? user['first_name'] ?? name,
            supplierBusinessName: contact['supplier_business_name'] ?? supplierBusinessName,
            addressLine1: contact['address_line_1'] ?? addressLine1,
            email: contact['email'] ?? user['email'] ?? email,
            profilePhoto: data['profile_photo'],
          );
        }
      } catch (e) {
        log('Error parsing update response: $e');
      }
    }
    return null;
  }

  // Save customer info locally for persistence
  static Future<void> saveCustomerInfoLocally(CustomerInfo customerInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'name': customerInfo.name,
      'phone': customerInfo.phone,
      'email': customerInfo.email,
      'addressLine1': customerInfo.addressLine1,
      'supplierBusinessName': customerInfo.supplierBusinessName,
      'profilePhoto': customerInfo.profilePhoto,
    };
    await prefs.setString('cached_customer_info', jsonEncode(cacheData));
    log('Saved to cache: ${jsonEncode(cacheData)}');
  }

  // Get cached customer info
  static Future<CustomerInfo?> getCachedCustomerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_customer_info');
    log('Retrieved from cache: $cachedData');
    if (cachedData != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(cachedData);
        final customerInfo = CustomerInfo(
          userId: 0,
          name: data['name'] ?? '',
          phone: data['phone'],
          email: data['email'] ?? '',
          addressLine1: data['addressLine1'] ?? '',
          supplierBusinessName: data['supplierBusinessName'] ?? '',
          profilePhoto: data['profilePhoto'],
        );
        log('Parsed cached customer info: ${customerInfo.name}');
        return customerInfo;
      } catch (e) {
        log('Error parsing cached customer info: $e');
      }
    }
    return null;
  }
} 