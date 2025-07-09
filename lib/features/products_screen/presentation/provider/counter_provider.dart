// import 'package:flutter/material.dart';
//
// import '../../model/items_list.dart';
//
// // import '../model/items_list.dart';
//
// // import 'model_test_product_cart.dart';
//
// class CounterProvider extends ChangeNotifier {
//   // final List<Item> _cartItems = [];
//   double _price = 0.0;
//   // int _counter = 0;
//
//
//   double get totalPrice {
//     return _price;
//   }
//
//   // int get counterCount {
//   //   return _counter;
//   // }
//
//   void incrementCounter(index) {
//     groceryItems[index].counter++;
//     notifyListeners();
//   }
//
//   void decrementCounter(index) {
//     if ( groceryItems[index].counter > 0)
//       groceryItems[index].counter--;
//     notifyListeners();
//   }
// }
// import 'package:flutter/material.dart';
// import '../../model/product_model.dart';
//
// class CounterProvider extends ChangeNotifier {
//   final List<Products> _cartItems = []; // Cart list
//   double _totalPrice = 0.0;
//
//   List<Products> get cartItems => _cartItems;
//   double get totalPrice => _totalPrice;
//
//   // Increment the counter for a product
//   void incrementCounter(Products product) {
//     product.counter++;
//     if (!_cartItems.contains(product)) {
//       _cartItems.add(product);
//     }
//     _calculateTotal();
//     notifyListeners();
//   }
//
//   // Decrement the counter for a product
//   void decrementCounter(Products product) {
//     if (product.counter > 0) {
//       product.counter--;
//       if (product.counter == 0) {
//         _cartItems.remove(product); // Remove if quantity is 0
//       }
//     }
//     _calculateTotal();
//     notifyListeners();
//   }
//
//   // Calculate total price
//   void _calculateTotal() {
//     _totalPrice = _cartItems.fold(0.0, (sum, item) {
//       return sum + (double.tryParse(item?.price ?? '0') ?? 0) * item.counter;
//     });
//   }
//
//   // Clear the cart
//   void clearCart() {
//     _cartItems.clear();
//     _totalPrice = 0.0;
//     notifyListeners();
//   }
// }
