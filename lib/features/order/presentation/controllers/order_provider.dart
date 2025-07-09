import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/order/data/model/order_model.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.insert(0, order); // newest first
    notifyListeners();
  }
}
