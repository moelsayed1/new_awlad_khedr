import 'api_manager.dart';
import 'models/auth_models.dart';
import 'models/product_models.dart';
import 'models/cart_models.dart';
import 'models/order_models.dart';

class ApiExampleUsage {
  final ApiManager _apiManager = ApiManager();

  // Authentication Examples
  Future<void> loginExample() async {
    try {
      final loginResponse = await _apiManager.login('username', 'password');

      if (loginResponse.success) {
        print('Login successful!');
        print('Token: ${loginResponse.token}');
        print('User: ${loginResponse.user?.first_name}');
      } else {
        print('Login failed: ${loginResponse.message}');
      }
    } catch (e) {
      print('Login error: $e');
    }
  }

  Future<void> registerExample() async {
    try {
      final registerResponse = await _apiManager.register(
        surname: 'Doe',
        first_name: 'John',
        email: 'john@example.com',
        username: 'johndoe',
        password: 'password123',
        allow_mob: '1',
        mobile: '1234567890',
        address_line_1: '123 Main St',
        supplier_business_name: 'My Business',
        tax_card_image: '/path/to/tax_card.jpg',
        commercial_register_image: '/path/to/commercial_register.jpg',
      );

      if (registerResponse.success) {
        print('Registration successful!');
        print('User ID: ${registerResponse.data?.id}');
      } else {
        print('Registration failed: ${registerResponse.message}');
      }
    } catch (e) {
      print('Registration error: $e');
    }
  }

  Future<void> sendOtpExample() async {
    try {
      final otpResponse = await _apiManager.sendOtp('john@example.com');

      if (otpResponse.success) {
        print('OTP sent successfully!');
      } else {
        print('OTP send failed: ${otpResponse.message}');
      }
    } catch (e) {
      print('Send OTP error: $e');
    }
  }

  Future<void> resetPasswordExample() async {
    try {
      final resetResponse = await _apiManager.resetPassword(
        email: 'john@example.com',
        otp: '123456',
        password: 'newpassword123',
        password_confirmation: 'newpassword123',
      );

      if (resetResponse.success) {
        print('Password reset successful!');
      } else {
        print('Password reset failed: ${resetResponse.message}');
      }
    } catch (e) {
      print('Reset password error: $e');
    }
  }

  // Product Examples
  Future<void> getProductsExample() async {
    try {
      final productsResponse = await _apiManager.getAllProducts();

      if (productsResponse.success) {
        print('Products loaded: ${productsResponse.data?.length}');
        for (final product in productsResponse.data ?? []) {
          print('Product: ${product.name} - ${product.price}');
        }
      } else {
        print('Get products failed: ${productsResponse.message}');
      }
    } catch (e) {
      print('Get products error: $e');
    }
  }

  Future<void> getBannersExample() async {
    try {
      final bannersResponse = await _apiManager.getAllBanners();

      if (bannersResponse.success) {
        print('Banners loaded: ${bannersResponse.data?.length}');
        for (final banner in bannersResponse.data ?? []) {
          print('Banner: ${banner.title}');
        }
      } else {
        print('Get banners failed: ${bannersResponse.message}');
      }
    } catch (e) {
      print('Get banners error: $e');
    }
  }

  Future<void> searchProductsExample() async {
    try {
      final searchResponse = await _apiManager.searchProducts('phone');

      if (searchResponse.success) {
        print('Search results: ${searchResponse.data?.length}');
        for (final product in searchResponse.data ?? []) {
          print('Found: ${product.name}');
        }
      } else {
        print('Search failed: ${searchResponse.message}');
      }
    } catch (e) {
      print('Search error: $e');
    }
  }

  // Cart Examples
  Future<void> getCartExample() async {
    try {
      final cartResponse = await _apiManager.getCart();

      if (cartResponse.success) {
        print('Cart items: ${cartResponse.data?.length}');
        print('Total amount: ${cartResponse.total_amount}');
        for (final item in cartResponse.data ?? []) {
          print('Cart item: ${item.product_name} - Qty: ${item.quantity}');
        }
      } else {
        print('Get cart failed: ${cartResponse.message}');
      }
    } catch (e) {
      print('Get cart error: $e');
    }
  }

  Future<void> addToCartExample() async {
    try {
      final addResponse = await _apiManager.addToCart(
        product_id: 1,
        product_quantity: 2,
        price: 100.0,
      );

      if (addResponse.success) {
        print('Item added to cart successfully!');
        print('Cart item: ${addResponse.data?.product_name}');
      } else {
        print('Add to cart failed: ${addResponse.message}');
      }
    } catch (e) {
      print('Add to cart error: $e');
    }
  }

  Future<void> updateCartItemExample() async {
    try {
      final updateResponse = await _apiManager.updateCartItem(
        cartItemId: 1,
        product_id: 1,
        product_quantity: 3,
        price: 100.0,
      );

      if (updateResponse.success) {
        print('Cart item updated successfully!');
        print('New quantity: ${updateResponse.data?.quantity}');
      } else {
        print('Update cart item failed: ${updateResponse.message}');
      }
    } catch (e) {
      print('Update cart item error: $e');
    }
  }

  Future<void> deleteCartItemExample() async {
    try {
      final deleteResponse = await _apiManager.deleteCartItem(1);

      if (deleteResponse.success) {
        print('Cart item deleted successfully!');
      } else {
        print('Delete cart item failed: ${deleteResponse.message}');
      }
    } catch (e) {
      print('Delete cart item error: $e');
    }
  }

  // Order Examples
  Future<void> createOrderExample() async {
    try {
      final orderResponse = await _apiManager.storeSell(mobile: true);

      if (orderResponse.success) {
        print('Order created successfully!');
        print('Order ID: ${orderResponse.data?.id}');
        print('Order number: ${orderResponse.data?.order_number}');
      } else {
        print('Create order failed: ${orderResponse.message}');
      }
    } catch (e) {
      print('Create order error: $e');
    }
  }

  Future<void> getOrdersExample() async {
    try {
      final ordersResponse = await _apiManager.getAllOrders();

      if (ordersResponse.success) {
        print('Orders loaded: ${ordersResponse.data?.length}');
        for (final order in ordersResponse.data ?? []) {
          print('Order: ${order.order_number} - ${order.status}');
        }
      } else {
        print('Get orders failed: ${ordersResponse.message}');
      }
    } catch (e) {
      print('Get orders error: $e');
    }
  }

  Future<void> getTransactionsExample() async {
    try {
      final transactionsResponse = await _apiManager.getAllTransactions();

      if (transactionsResponse.success) {
        print('Transactions loaded: ${transactionsResponse.data?.length}');
        for (final transaction in transactionsResponse.data ?? []) {
          print(
              'Transaction: ${transaction.transaction_id} - ${transaction.amount}');
        }
      } else {
        print('Get transactions failed: ${transactionsResponse.message}');
      }
    } catch (e) {
      print('Get transactions error: $e');
    }
  }

  Future<void> getOrderInvoiceExample() async {
    try {
      final invoiceResponse = await _apiManager.getOrderInvoice(1234);

      if (invoiceResponse.success) {
        print('Invoice loaded successfully!');
        print('Invoice number: ${invoiceResponse.data?.invoice_number}');
        print('Total: ${invoiceResponse.data?.total}');
      } else {
        print('Get invoice failed: ${invoiceResponse.message}');
      }
    } catch (e) {
      print('Get invoice error: $e');
    }
  }

  // Utility Examples
  Future<void> checkAuthenticationExample() async {
    final isAuthenticated = _apiManager.isAuthenticated();
    print('Is authenticated: $isAuthenticated');

    if (isAuthenticated) {
      final token = _apiManager.getAuthToken();
      print('Auth token: $token');
    }
  }

  Future<void> logoutExample() async {
    _apiManager.logout();
    print('Logged out successfully');
  }

  // Complete workflow example
  Future<void> completeWorkflowExample() async {
    try {
      // 1. Login
      print('=== Login ===');
      final loginResponse = await _apiManager.login('username', 'password');
      if (!loginResponse.success) {
        print('Login failed, stopping workflow');
        return;
      }

      // 2. Get products
      print('=== Get Products ===');
      final productsResponse = await _apiManager.getAllProducts();
      if (productsResponse.success && productsResponse.data!.isNotEmpty) {
        final firstProduct = productsResponse.data!.first;

        // 3. Add to cart
        print('=== Add to Cart ===');
        final addToCartResponse = await _apiManager.addToCart(
          product_id: firstProduct.id!,
          product_quantity: 1,
          price: firstProduct.price!,
        );

        if (addToCartResponse.success) {
          // 4. Get cart
          print('=== Get Cart ===');
          final cartResponse = await _apiManager.getCart();
          if (cartResponse.success) {
            print('Cart total: ${cartResponse.total_amount}');
          }

          // 5. Create order
          print('=== Create Order ===');
          final orderResponse = await _apiManager.storeSell(mobile: true);
          if (orderResponse.success) {
            print('Order created: ${orderResponse.data?.order_number}');
          }
        }
      }

      // 6. Logout
      print('=== Logout ===');
      _apiManager.logout();
    } catch (e) {
      print('Workflow error: $e');
    }
  }
}
