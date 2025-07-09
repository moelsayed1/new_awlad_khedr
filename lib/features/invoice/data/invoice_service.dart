import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constant.dart';
import 'dart:developer';

class OrderResult {
  final bool success;
  final String? invoiceNo;
  final String? error;

  OrderResult.success(this.invoiceNo)
      : success = true,
        error = null;
  OrderResult.error(this.error)
      : success = false,
        invoiceNo = null;
}

class InvoiceService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<dynamic>> getAllOrders() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(APIConstant.GET_ALL_ORDERS),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['orders'] ?? [];
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<dynamic>> getAllTransactions() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(APIConstant.GET_ALL_TRANSACTIONS),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['transactions'] ?? [];
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  static Future<OrderResult> placeOrder({
    required List products,
    required List<int> quantities,
    required double total,
  }) async {
    final token = await getToken();
    if (token == null) return OrderResult.error('Token is null');

    log('placeOrder: products=$products, quantities=$quantities, total=$total');
    for (int i = 0; i < products.length; i++) {
      final p = products[i];
      String name = '';
      int? id;
      num? price;
      if (p is Map<String, dynamic>) {
        name = p['product_name']?.toString() ?? p['name']?.toString() ?? 'NO_NAME';
        id = p['product_id'] is int ? p['product_id'] : int.tryParse(p['product_id']?.toString() ?? '');
        price = p['price'] is num ? p['price'] : num.tryParse(p['price']?.toString() ?? '0');
      } else {
        try {
          name = p.productName ?? p.name ?? 'NO_NAME';
          id = p.productId;
          price = p.price is num ? p.price : num.tryParse(p.price?.toString() ?? '0');
        } catch (_) {
          name = 'NO_NAME';
        }
      }
      log('placeOrder: product[$i] runtimeType=${p.runtimeType}, name=$name, id=$id, price=$price, quantity=${quantities[i]}');
    }

    List<Map<String, dynamic>> items;
    try {
      items = List.generate(products.length, (i) {
        final p = products[i];
        int? id;
        num? price;
        if (p is Map<String, dynamic>) {
          id = p['product_id'] is int ? p['product_id'] : int.tryParse(p['product_id']?.toString() ?? '');
          price = p['price'] is num ? p['price'] : num.tryParse(p['price']?.toString() ?? '0');
        } else {
          id = p.productId;
          price = p.price is num ? p.price : num.tryParse(p.price?.toString() ?? '0');
        }
        return {
          'product_id': id,
          'quantity': quantities[i],
          'price': price,
        };
      });
    } catch (e, stack) {
      log('Exception building payload: $e\n$stack');
      return OrderResult.error('Exception building payload: $e');
    }
    final payload = {'items': items, 'total': total, 'mobile': true};

    try {
      final response = await http.post(
        Uri.parse(APIConstant.STORE_SELL),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      ).timeout(const Duration(seconds: 15));

      log('Order payload: $payload');
      log('Order response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return OrderResult.success(data["transaction"]?["invoice_no"]);
      } else {
        return OrderResult.error('Order failed: ${response.body}');
      }
    } catch (e, stack) {
      log('Order exception: $e\n$stack');
      return OrderResult.error('Exception: $e');
    }
  }

  Future<Map<String, dynamic>?> getOrder(int orderId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_ORDER}/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getOrderInvoice(int orderId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_ORDER_INVOICE}/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order-invoice'];
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getTransactionInvoice(int transactionId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${APIConstant.GET_TRANSACTION_INVOICE}/$transactionId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['order-invoice'];
    } else {
      return null;
    }
  }
} 