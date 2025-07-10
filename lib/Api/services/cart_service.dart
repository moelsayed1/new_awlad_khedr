import '../api_constants.dart';
import '../models/cart_models.dart';
import '../models/auth_models.dart';
import 'api_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final ApiService _apiService = ApiService();

  // Get cart items
  Future<CartResponse> getCart() async {
    try {
      final response = await _apiService.get(ApiConstants.cart);
      final responseData = _apiService.handleResponse(response);
      return CartResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Get cart failed: $e');
    }
  }

  // Add item to cart
  Future<ApiResponse<CartItem>> addToCart(AddToCartRequest request) async {
    try {
      final response = await _apiService.postFormData(
        ApiConstants.cart,
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, CartItem.fromJson);
    } catch (e) {
      throw Exception('Add to cart failed: $e');
    }
  }

  // Update cart item
  Future<ApiResponse<CartItem>> updateCartItem(int cartItemId, UpdateCartRequest request) async {
    try {
      final response = await _apiService.postFormData(
        '${ApiConstants.cart}/$cartItemId',
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, CartItem.fromJson);
    } catch (e) {
      throw Exception('Update cart item failed: $e');
    }
  }

  // Delete cart item
  Future<ApiResponse<dynamic>> deleteCartItem(int cartItemId) async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.cartDelete}/$cartItemId',
        {},
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Delete cart item failed: $e');
    }
  }

  // Clear cart
  Future<ApiResponse<dynamic>> clearCart() async {
    try {
      final response = await _apiService.post(
        '${ApiConstants.cart}/clear',
        {},
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, (json) => json);
    } catch (e) {
      throw Exception('Clear cart failed: $e');
    }
  }

  // Get cart summary
  Future<ApiResponse<CartSummary>> getCartSummary() async {
    try {
      final response = await _apiService.get('${ApiConstants.cart}/summary');
      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, CartSummary.fromJson);
    } catch (e) {
      throw Exception('Get cart summary failed: $e');
    }
  }

  // Update cart item quantity
  Future<ApiResponse<CartItem>> updateCartItemQuantity(int cartItemId, int quantity) async {
    try {
      final request = UpdateCartRequest(
        product_id: cartItemId,
        product_quantity: quantity,
        price: 0.0, // This will be ignored by the server
      );

      final response = await _apiService.postFormData(
        '${ApiConstants.cart}/$cartItemId',
        request.toFormData(),
      );

      final responseData = _apiService.handleResponse(response);
      return ApiResponse.fromJson(responseData, CartItem.fromJson);
    } catch (e) {
      throw Exception('Update cart item quantity failed: $e');
    }
  }

  // Check if cart is empty
  Future<bool> isCartEmpty() async {
    try {
      final cartResponse = await getCart();
      return cartResponse.data == null || cartResponse.data!.isEmpty;
    } catch (e) {
      return true; // Assume empty if error
    }
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    try {
      final cartResponse = await getCart();
      return cartResponse.total_items ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get cart total amount
  Future<double> getCartTotalAmount() async {
    try {
      final cartResponse = await getCart();
      return cartResponse.total_amount ?? 0.0;
    } catch (e) {
      return 0.0;
    }
  }
} 