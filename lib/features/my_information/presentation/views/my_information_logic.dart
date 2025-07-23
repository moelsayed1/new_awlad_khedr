import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../../constant.dart';
import 'dart:io';

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
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        return CustomerInfo.fromJson(data[0]);
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

  static Future<bool> updateUserDataWithPhoto(
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

    return response.statusCode == 200;
  }
} 