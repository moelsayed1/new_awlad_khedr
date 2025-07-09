import 'package:flutter/material.dart';
import 'invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final InvoiceService _invoiceService = InvoiceService();

  List<dynamic> _orders = [];
  List<dynamic> get orders => _orders;

  List<dynamic> _transactions = [];
  List<dynamic> get transactions => _transactions;

  bool _isLoadingOrders = false;
  bool get isLoadingOrders => _isLoadingOrders;

  bool _isLoadingTransactions = false;
  bool get isLoadingTransactions => _isLoadingTransactions;

  String? _error;
  String? get error => _error;

  Map<String, dynamic>? _orderDetails;
  Map<String, dynamic>? get orderDetails => _orderDetails;

  Map<String, dynamic>? _orderInvoice;
  Map<String, dynamic>? get orderInvoice => _orderInvoice;

  Map<String, dynamic>? _transactionInvoice;
  Map<String, dynamic>? get transactionInvoice => _transactionInvoice;

  bool _isLoadingOrderDetails = false;
  bool get isLoadingOrderDetails => _isLoadingOrderDetails;

  bool _isLoadingOrderInvoice = false;
  bool get isLoadingOrderInvoice => _isLoadingOrderInvoice;

  bool _isLoadingTransactionInvoice = false;
  bool get isLoadingTransactionInvoice => _isLoadingTransactionInvoice;

  Future<void> fetchOrders() async {
    _isLoadingOrders = true;
    _error = null;
    notifyListeners();
    try {
      _orders = await _invoiceService.getAllOrders();
    } catch (e) {
      _error = e.toString();
      _orders = [];
    }
    _isLoadingOrders = false;
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    _isLoadingTransactions = true;
    _error = null;
    notifyListeners();
    try {
      _transactions = await _invoiceService.getAllTransactions();
    } catch (e) {
      _error = e.toString();
      _transactions = [];
    }
    _isLoadingTransactions = false;
    notifyListeners();
  }

  Future<void> fetchOrderDetails(int orderId) async {
    _isLoadingOrderDetails = true;
    _error = null;
    notifyListeners();
    try {
      _orderDetails = await _invoiceService.getOrder(orderId);
    } catch (e) {
      _error = e.toString();
      _orderDetails = null;
    }
    _isLoadingOrderDetails = false;
    notifyListeners();
  }

  Future<void> fetchOrderInvoice(int orderId) async {
    _isLoadingOrderInvoice = true;
    _error = null;
    notifyListeners();
    try {
      _orderInvoice = await _invoiceService.getOrderInvoice(orderId);
    } catch (e) {
      _error = e.toString();
      _orderInvoice = null;
    }
    _isLoadingOrderInvoice = false;
    notifyListeners();
  }

  Future<void> fetchTransactionInvoice(int transactionId) async {
    _isLoadingTransactionInvoice = true;
    _error = null;
    notifyListeners();
    try {
      _transactionInvoice = await _invoiceService.getTransactionInvoice(transactionId);
    } catch (e) {
      _error = e.toString();
      _transactionInvoice = null;
    }
    _isLoadingTransactionInvoice = false;
    notifyListeners();
  }
} 