import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/order/data/model/order_model.dart';
import 'package:awlad_khedr/constant.dart';
import 'dart:convert';
import 'package:awlad_khedr/core/network/api_service.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  String? _highlightedInvoiceNo;

  List<Order> get orders => _orders;
  String? get highlightedInvoiceNo => _highlightedInvoiceNo;

  Future<void> fetchOrders({String? highlightInvoiceNo}) async {
    try {
      final apiService = ApiService();
      await apiService.init();
      final token = apiService.currentToken;
      if (token == null || token.isEmpty) {
        throw Exception('No auth token found. Please log in.');
      }
      final response = await apiService.get(
        Uri.parse(APIConstant.GET_ALL_ORDERS),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Order> loadedOrders = [];
        for (var orderJson in data['orders']) {
          loadedOrders.add(Order(
            id: orderJson['invoice_number'] ?? '',
            invoiceId: orderJson['invoice_id'] ?? 0,
            date: DateTime.tryParse(orderJson['create_date'] ?? '') ?? DateTime.now(),
            products: [], // You can fetch products for each order if needed
            total: double.tryParse(orderJson['final_total'].toString()) ?? 0.0,
            status: '', // Add status if available in API
          ));
        }
        _orders.clear();
        _orders.addAll(loadedOrders);
        _highlightedInvoiceNo = highlightInvoiceNo;
        notifyListeners();
      } else {
        print('Failed to load orders. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error in fetchOrders: $e');
      rethrow;
    }
  }

  void addOrder(Order order) {
    _orders.insert(0, order); // newest first
    notifyListeners();
  }
}
