import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:awlad_khedr/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceServiceResult {
  final bool success;
  final String? invoiceNo;
  final String? error;
  InvoiceServiceResult({required this.success, this.invoiceNo, this.error});
}

class InvoiceService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<InvoiceServiceResult> placeSaleOrder({
    required String token,
    required String userId,
    required List<dynamic> products,
    required List<int> quantities,
    required double total,
  }) async {
    try {
      final String? baseUrl = APIConstant.BASE_URL;
      if (baseUrl == null) {
        return InvoiceServiceResult(success: false, error: 'Base URL not configured.');
      }
      final Uri uri = Uri.parse(APIConstant.STORE_ORDER);

      final List<Map<String, dynamic>> items = [];
      for (int i = 0; i < products.length; i++) {
        final product = products[i];
        final quantity = quantities[i];
        final price = product.price?.toString() ?? '0.0';
        items.add({
          "product_id": product.productId?.toString() ?? '',
          "product_quantity": quantity.toString(),
          "price": price,
        });
      }

      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          "user_id": userId,
          "total_price": total.toString(),
          "items": items,
        }),
      );

      log('Place sale order response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final String? invoiceNo = responseBody['invoice_no']?.toString() ?? responseBody['message']?.toString();
        return InvoiceServiceResult(success: true, invoiceNo: invoiceNo);
      } else {
        final errorBody = json.decode(response.body);
        final String errorMessage = errorBody['message']?.toString() ?? 'Failed to place order.';
        return InvoiceServiceResult(success: false, error: 'Error ${response.statusCode}: $errorMessage');
      }
    } catch (e, stack) {
      log('Exception placing sale order: $e\n$stack');
      return InvoiceServiceResult(success: false, error: 'حدث خطأ غير متوقع أثناء إرسال الطلب: $e');
    }
  }

  Future<List<dynamic>> getAllOrders() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_ORDERS),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['orders'] ?? [];
      } else {
        log('Failed to load orders: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error in getAllOrders: $e');
      return [];
    }
  }

  Future<List<dynamic>> getAllTransactions() async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse(APIConstant.GET_ALL_TRANSACTIONS),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['transactions'] ?? [];
      } else {
        log('Failed to load transactions: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('Error in getAllTransactions: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getOrder(int orderId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${APIConstant.GET_ORDER}/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order'];
      } else {
        log('Failed to load order: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error in getOrder: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderInvoice(int orderId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${APIConstant.GET_ORDER_INVOICE}/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order-invoice'];
      } else {
        log('Failed to load order invoice: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error in getOrderInvoice: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTransactionInvoice(int transactionId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${APIConstant.GET_TRANSACTION_INVOICE}/$transactionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['order-invoice'];
      } else {
        log('Failed to load transaction invoice: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error in getTransactionInvoice: $e');
      return null;
    }
  }
} 