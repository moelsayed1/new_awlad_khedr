import 'package:flutter/material.dart';
import '../../Api/api_manager.dart';
import '../../Api/models/cart_models.dart';

class CartProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();

  bool _isLoading = false;
  List<CartItem> _cartItems = [];
  String? _errorMessage;

  // Getters
  bool get isLoading => _isLoading;
  List<CartItem> get cartItems => _cartItems;
  String? get errorMessage => _errorMessage;

  // Calculate total amount
  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) {
      final price = item.price ?? 0;
      return sum + (price * (item.quantity ?? 0));
    });
  }

  // Load cart
  Future<void> loadCart() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.getCart();

      if (response.success) {
        _cartItems = response.data ?? [];
        _setLoading(false);
        notifyListeners();
      } else {
        _errorMessage = response.message ?? 'Failed to load cart';
        _setLoading(false);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      notifyListeners();
    }
  }

  // Add to cart
  Future<bool> addToCart(int productId, int quantity, double price) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.addToCart(
        product_id: productId,
        product_quantity: quantity,
        price: price,
      );

      if (response.success) {
        // Reload cart to get updated data
        await loadCart();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to add to cart';
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

  // Update cart item quantity
  Future<bool> updateCartItemQuantity(int cartItemId, int newQuantity) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.updateCartItemQuantity(cartItemId, newQuantity);

      if (response.success) {
        // Reload cart to get updated data
        await loadCart();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to update cart item';
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

  // Delete cart item
  Future<bool> deleteCartItem(int cartItemId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.deleteCartItem(cartItemId);

      if (response.success) {
        // Reload cart to get updated data
        await loadCart();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to delete cart item';
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

  // Clear cart
  Future<bool> clearCart() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.clearCart();

      if (response.success) {
        _cartItems = [];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to clear cart';
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

  // Create order from cart
  Future<bool> createOrder() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiManager.storeSell(mobile: false);

      if (response.success) {
        // Clear cart after successful order
        _cartItems = [];
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message ?? 'Failed to create order';
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

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _errorMessage = null;
  }
}
