import 'package:flutter/material.dart';
import '../../Api/api_manager.dart';
import '../../Api/models/order_models.dart';

class OrderProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();

  bool _isLoading = false;
  List<Order> _orders = [];
  List<Transaction> _transactions = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<Order> get orders => _orders;
  List<Transaction> get transactions => _transactions;
  String? get errorMessage => _errorMessage;

  // Load all orders
  Future<void> loadOrders() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getAllOrders();

      if (response.success) {
        _orders = response.data ?? [];
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load orders';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Load all transactions
  Future<void> loadTransactions() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getAllTransactions();

      if (response.success) {
        _transactions = response.data ?? [];
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load transactions';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Get order by ID
  Future<Order?> getOrderById(int orderId) async {
    try {
      final response = await _apiManager.getOrderById(orderId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get transaction by ID
  Future<Transaction?> getTransactionById(int transactionId) async {
    try {
      final response = await _apiManager.getTransactionById(transactionId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get orders by status
  Future<List<Order>> getOrdersByStatus(String status) async {
    try {
      final response = await _apiManager.getOrdersByStatus(status);
      if (response.success) {
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Get transactions by type
  Future<List<Transaction>> getTransactionsByType(String type) async {
    try {
      final response = await _apiManager.getTransactionsByType(type);
      if (response.success) {
        return response.data ?? [];
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.cancelOrder(orderId);

      if (response.success) {
        // Reload orders
        await loadOrders();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to cancel order';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(int orderId, String status) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.updateOrderStatus(orderId, status);

      if (response.success) {
        // Reload orders
        await loadOrders();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update order status';
        _setLoading(false);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  // Get order invoice
  Future<Invoice?> getOrderInvoice(int orderId) async {
    try {
      final response = await _apiManager.getOrderInvoice(orderId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get transaction invoice
  Future<Invoice?> getTransactionInvoice(int transactionId) async {
    try {
      final response = await _apiManager.getTransactionInvoice(transactionId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get order statistics
  Future<Map<String, dynamic>?> getOrderStatistics() async {
    try {
      final response = await _apiManager.getOrderStatistics();
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get transaction statistics
  Future<Map<String, dynamic>?> getTransactionStatistics() async {
    try {
      final response = await _apiManager.getTransactionStatistics();
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Download invoice PDF
  Future<String?> downloadInvoicePdf(int orderId) async {
    try {
      final response = await _apiManager.downloadInvoicePdf(orderId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Download transaction invoice PDF
  Future<String?> downloadTransactionInvoicePdf(int transactionId) async {
    try {
      final response =
          await _apiManager.downloadTransactionInvoicePdf(transactionId);
      if (response.success) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
