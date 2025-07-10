import '../api_constants.dart';
import '../models/order_models.dart';
import '../models/auth_models.dart';
import 'api_service.dart';

class OrderService {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final ApiService _apiService = ApiService();

  // Store sell (create order from cart)
  Future<ApiResponse<Order>> storeSell(StoreSellRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.storeSell,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Order.fromJson);
    } catch (e) {
      throw Exception('Store sell failed: $e');
    }
  }

  // Get all orders
  Future<OrdersResponse> getAllOrders() async {
    try {
      final response = await _apiService.get(ApiConstants.orders);
      final responseData = _apiService.handleResponse(response);
      return OrdersResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get orders failed: $e');
    }
  }

  // Get all transactions
  Future<TransactionsResponse> getAllTransactions() async {
    try {
      final response = await _apiService.get(ApiConstants.transactions);
      final responseData = _apiService.handleResponse(response);
      return TransactionsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get transactions failed: $e');
    }
  }

  // Get order by ID
  Future<ApiResponse<Order>> getOrderById(int orderId) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.orderDetails}/$orderId');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Order.fromJson);
    } catch (e) {
      throw Exception('Get order by ID failed: $e');
    }
  }

  // Get transaction by ID
  Future<ApiResponse<Transaction>> getTransactionById(int transactionId) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.transactions}/$transactionId');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Transaction.fromJson);
    } catch (e) {
      throw Exception('Get transaction by ID failed: $e');
    }
  }

  // Get order invoice
  Future<ApiResponse<Invoice>> getOrderInvoice(int orderId) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.orderInvoice}/$orderId');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Invoice.fromJson);
    } catch (e) {
      throw Exception('Get order invoice failed: $e');
    }
  }

  // Get transaction invoice
  Future<ApiResponse<Invoice>> getTransactionInvoice(int transactionId) async {
    try {
      final response = await _apiService
          .get('${ApiConstants.transactionInvoice}/$transactionId');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Invoice.fromJson);
    } catch (e) {
      throw Exception('Get transaction invoice failed: $e');
    }
  }

  // Get orders by status
  Future<OrdersResponse> getOrdersByStatus(String status) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.orders}?status=$status');
      final responseData = _apiService.handleResponse(response);
      return OrdersResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get orders by status failed: $e');
    }
  }

  // Get transactions by type
  Future<TransactionsResponse> getTransactionsByType(String type) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.transactions}?type=$type');
      final responseData = _apiService.handleResponse(response);
      return TransactionsResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get transactions by type failed: $e');
    }
  }

  // Cancel order
  Future<ApiResponse<dynamic>> cancelOrder(int orderId) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.orderDetails}/$orderId/cancel',
        {},
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Cancel order failed: $e');
    }
  }

  // Update order status
  Future<ApiResponse<Order>> updateOrderStatus(
      int orderId, String status) async {
    try {
      final response = await _apiService.postFormData(
        '${ApiConstants.orderDetails}/$orderId/status',
        {'status': status},
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, Order.fromJson);
    } catch (e) {
      throw Exception('Update order status failed: $e');
    }
  }

  // Get order statistics
  Future<ApiResponse<Map<String, dynamic>>> getOrderStatistics() async {
    try {
      final response =
          await _apiService.get('${ApiConstants.orders}/statistics');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Get order statistics failed: $e');
    }
  }

  // Get transaction statistics
  Future<ApiResponse<Map<String, dynamic>>> getTransactionStatistics() async {
    try {
      final response =
          await _apiService.get('${ApiConstants.transactions}/statistics');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Get transaction statistics failed: $e');
    }
  }

  // Download invoice PDF
  Future<ApiResponse<String>> downloadInvoicePdf(int orderId) async {
    try {
      final response =
          await _apiService.get('${ApiConstants.orderInvoice}/$orderId/pdf');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(
          responseData, (json) => json['pdf_url'] as String);
    } catch (e) {
      throw Exception('Download invoice PDF failed: $e');
    }
  }

  // Download transaction invoice PDF
  Future<ApiResponse<String>> downloadTransactionInvoicePdf(
      int transactionId) async {
    try {
      final response = await _apiService
          .get('${ApiConstants.transactionInvoice}/$transactionId/pdf');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(
          responseData, (json) => json['pdf_url'] as String);
    } catch (e) {
      throw Exception('Download transaction invoice PDF failed: $e');
    }
  }
}
