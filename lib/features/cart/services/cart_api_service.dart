import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../../constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartApiService {
  static String? _authToken;
  static bool _tokenValidated = false;

  /// Get authentication token
  static Future<String?> _getToken() async {
    if (_authToken != null) return _authToken;
    
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('token');
    return _authToken;
  }

  /// Validate token
  static Future<bool> _validateToken() async {
    if (_tokenValidated && _authToken != null) return true;
    
    final token = await _getToken();
    if (token == null) return false;
    
    _tokenValidated = true;
    return true;
  }

  /// UPDATE endpoint - for + button
  /// POST /api/cart/{cartId}
  static Future<bool> updateCartItem({
    required int cartId,
    required int productId,
    required int quantity,
    required double price,
  }) async {
    log('🔄 UPDATE Cart Item - CartID: $cartId, ProductID: $productId, Quantity: $quantity, Price: $price');
    
    try {
      if (!await _validateToken()) {
        log('❌ Invalid or expired token in updateCartItem');
        return false;
      }

      final response = await http.post(
        Uri.parse('${APIConstant.UPDATE_CART}/$cartId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'product_id': productId.toString(),
          'product_quantity': quantity.toString(),
          'price': price.toString(),
        },
      );

      log('📡 UPDATE Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Cart item updated successfully');
        return true;
      } else if (response.statusCode == 404) {
        log('⚠️ Cart item $cartId not found during update');
        return false;
      } else if (response.statusCode == 401) {
        _tokenValidated = false;
        log('❌ Token expired during updateCartItem');
        return false;
      } else {
        log('❌ Unexpected status code in updateCartItem: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('❌ Error in updateCartItem: $e');
      return false;
    }
  }

  /// DELETE endpoint - for - button
  /// POST /api/cart/delete/{cartId}
  static Future<bool> deleteCartItem({
    required int cartId,
  }) async {
    log('🗑️ DELETE Cart Item - CartID: $cartId');
    
    try {
      if (!await _validateToken()) {
        log('❌ Invalid or expired token in deleteCartItem');
        return false;
      }

      final response = await http.post(
        Uri.parse('${APIConstant.DELETE_CART}/$cartId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
      );

      log('📡 DELETE Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        log('✅ Cart item deleted successfully');
        return true;
      } else if (response.statusCode == 404) {
        log('⚠️ Cart item $cartId not found - considering it deleted');
        return true;
      } else if (response.statusCode == 401) {
        _tokenValidated = false;
        log('❌ Token expired during deleteCartItem');
        return false;
      } else {
        log('❌ Unexpected status code in deleteCartItem: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('❌ Error in deleteCartItem: $e');
      return false;
    }
  }

  /// STORE endpoint - for "Go to Cart" button
  /// POST /api/cart
  static Future<bool> addProductToCart({
    required int productId,
    required int quantity,
    required double price,
  }) async {
    log('🛒 STORE Cart Item - ProductID: $productId, Quantity: $quantity, Price: $price');
    
    try {
      if (!await _validateToken()) {
        log('❌ Invalid or expired token in addProductToCart');
        return false;
      }

      final response = await http.post(
        Uri.parse(APIConstant.STORE_TO_CART),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'product_id': productId.toString(),
          'product_quantity': quantity.toString(),
          'price': price.toString(),
        },
      );

      log('📡 STORE Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Product added to cart successfully');
        return true;
      } else if (response.statusCode == 401) {
        _tokenValidated = false;
        log('❌ Token expired during addProductToCart');
        return false;
      } else {
        log('❌ Unexpected status code in addProductToCart: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('❌ Error in addProductToCart: $e');
      return false;
    }
  }

  /// Get cart items from API
  /// GET /api/cart
  static Future<List<dynamic>> fetchCartFromApi() async {
    log('📋 Fetching cart from API');
    
    try {
      if (!await _validateToken()) {
        log('❌ Invalid or expired token in fetchCartFromApi');
        return [];
      }

      final response = await http.get(
        Uri.parse(APIConstant.GET_STORED_CART),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
      );

      log('📡 GET Cart Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is List<dynamic>) {
          log('✅ Successfully fetched ${decodedData.length} cart items');
          return decodedData;
        } else {
          log('❌ Unexpected data type from API for cart: ${decodedData.runtimeType}. Expected a List.');
          return [];
        }
      } else if (response.statusCode == 401) {
        _tokenValidated = false;
        log('❌ Token expired during fetchCartFromApi');
        return [];
      } else if (response.statusCode == 404) {
        log('ℹ️ Cart not found - returning empty list');
        return [];
      } else {
        log('❌ Unexpected status code in fetchCartFromApi: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      log('❌ Error in fetchCartFromApi: $e');
      return [];
    }
  }
} 