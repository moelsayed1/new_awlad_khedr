import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../constant.dart';

class CustomerInfo {
  final int userId;
  final String? phone;
  final String name;
  final String supplierBusinessName;
  final String addressLine1;
  final String email;

  CustomerInfo({
    required this.userId,
    required this.phone,
    required this.name,
    required this.supplierBusinessName,
    required this.addressLine1,
    required this.email,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      userId: json['user_id'],
      phone: json['phone'],
      name: json['name'],
      supplierBusinessName: json['supplier_business_name'],
      addressLine1: json['address_line_1'],
      email: json['email'],
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
} 