import 'models/auth_models.dart';
import 'models/product_models.dart';
import 'models/cart_models.dart';
import 'models/order_models.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/product_service.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();
  factory ApiManager() => _instance;
  ApiManager._internal();

  // Services
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final OrderService _orderService = OrderService();
  final ApiService _apiService = ApiService();

  // Getters for services
  AuthService get auth => _authService;
  ProductService get products => _productService;
  CartService get cart => _cartService;
  OrderService get orders => _orderService;

  // Authentication methods
  Future<LoginResponse> login(String username, String password) async {
    final request = LoginRequest(username: username, password: password);
    return await _authService.login(request);
  }

  Future<ApiResponse<UserData>> register({
    required String surname,
    required String first_name,
    required String email,
    required String username,
    required String password,
    required String allow_mob,
    required String mobile,
    required String address_line_1,
    required String supplier_business_name,
    String? tax_card_image,
    String? commercial_register_image,
  }) async {
    final request = RegisterRequest(
      surname: surname,
      first_name: first_name,
      email: email,
      username: username,
      password: password,
      allow_mob: allow_mob,
      mobile: mobile,
      address_line_1: address_line_1,
      supplier_business_name: supplier_business_name,
      tax_card_image: tax_card_image,
      commercial_register_image: commercial_register_image,
    );
    return await _authService.register(request);
  }

  Future<ApiResponse<UserData>> updateUser({
    required String first_name,
    required String email,
    required int id,
  }) async {
    final request = UpdateUserRequest(
      first_name: first_name,
      email: email,
      id: id,
    );
    return await _authService.updateUser(request);
  }

  Future<ApiResponse<dynamic>> sendOtp(String email) async {
    final request = SendOtpRequest(email: email);
    return await _authService.sendOtp(request);
  }

  Future<ApiResponse<dynamic>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String password_confirmation,
  }) async {
    final request = ResetPasswordRequest(
      email: email,
      otp: otp,
      password: password,
      password_confirmation: password_confirmation,
    );
    return await _authService.resetPassword(request);
  }

  Future<ApiResponse<dynamic>> sendVerificationEmail(String email) async {
    final request = SendVerificationEmailRequest(email: email);
    return await _authService.sendVerificationEmail(request);
  }

  Future<ApiResponse<UserData>> getCustomerData() async {
    return await _authService.getCustomerData();
  }

  // Product methods
  Future<ProductsResponse> getAllProducts() async {
    return await _productService.getAllProducts();
  }

  Future<BannersResponse> getAllBanners() async {
    return await _productService.getAllBanners();
  }

  Future<ApiResponse<TotalSold>> getTotalSold() async {
    return await _productService.getTotalSold();
  }

  Future<CategoryProductsResponse> getCategoryProducts() async {
    return await _productService.getCategoryProducts();
  }

  Future<ProductsResponse> getProductsByCategory(int categoryId) async {
    return await _productService.getProductsByCategory(categoryId);
  }

  Future<ProductsResponse> searchProducts(String query) async {
    return await _productService.searchProducts(query);
  }

  Future<ApiResponse<Product>> getProductById(int productId) async {
    return await _productService.getProductById(productId);
  }

  Future<ProductsResponse> getMostPopularProducts() async {
    return await _productService.getMostPopularProducts();
  }

  Future<ProductsResponse> getFeaturedProducts() async {
    return await _productService.getFeaturedProducts();
  }

  // Cart methods
  Future<CartResponse> getCart() async {
    return await _cartService.getCart();
  }

  Future<ApiResponse<CartItem>> addToCart({
    required int product_id,
    required int product_quantity,
    required double price,
  }) async {
    final request = AddToCartRequest(
      product_id: product_id,
      product_quantity: product_quantity,
      price: price,
    );
    return await _cartService.addToCart(request);
  }

  Future<ApiResponse<CartItem>> updateCartItem({
    required int cartItemId,
    required int product_id,
    required int product_quantity,
    required double price,
  }) async {
    final request = UpdateCartRequest(
      product_id: product_id,
      product_quantity: product_quantity,
      price: price,
    );
    return await _cartService.updateCartItem(cartItemId, request);
  }

  Future<ApiResponse<dynamic>> deleteCartItem(int cartItemId) async {
    return await _cartService.deleteCartItem(cartItemId);
  }

  Future<ApiResponse<dynamic>> clearCart() async {
    return await _cartService.clearCart();
  }

  Future<ApiResponse<CartSummary>> getCartSummary() async {
    return await _cartService.getCartSummary();
  }

  Future<ApiResponse<CartItem>> updateCartItemQuantity(
      int cartItemId, int quantity) async {
    return await _cartService.updateCartItemQuantity(cartItemId, quantity);
  }

  Future<bool> isCartEmpty() async {
    return await _cartService.isCartEmpty();
  }

  Future<int> getCartItemCount() async {
    return await _cartService.getCartItemCount();
  }

  Future<double> getCartTotalAmount() async {
    return await _cartService.getCartTotalAmount();
  }

  // Order methods
  Future<ApiResponse<Order>> storeSell({required bool mobile}) async {
    final request = StoreSellRequest(mobile: mobile);
    return await _orderService.storeSell(request);
  }

  Future<OrdersResponse> getAllOrders() async {
    return await _orderService.getAllOrders();
  }

  Future<TransactionsResponse> getAllTransactions() async {
    return await _orderService.getAllTransactions();
  }

  Future<ApiResponse<Order>> getOrderById(int orderId) async {
    return await _orderService.getOrderById(orderId);
  }

  Future<ApiResponse<Transaction>> getTransactionById(int transactionId) async {
    return await _orderService.getTransactionById(transactionId);
  }

  Future<ApiResponse<Invoice>> getOrderInvoice(int orderId) async {
    return await _orderService.getOrderInvoice(orderId);
  }

  Future<ApiResponse<Invoice>> getTransactionInvoice(int transactionId) async {
    return await _orderService.getTransactionInvoice(transactionId);
  }

  Future<OrdersResponse> getOrdersByStatus(String status) async {
    return await _orderService.getOrdersByStatus(status);
  }

  Future<TransactionsResponse> getTransactionsByType(String type) async {
    return await _orderService.getTransactionsByType(type);
  }

  Future<ApiResponse<dynamic>> cancelOrder(int orderId) async {
    return await _orderService.cancelOrder(orderId);
  }

  Future<ApiResponse<Order>> updateOrderStatus(
      int orderId, String status) async {
    return await _orderService.updateOrderStatus(orderId, status);
  }

  Future<ApiResponse<Map<String, dynamic>>> getOrderStatistics() async {
    return await _orderService.getOrderStatistics();
  }

  Future<ApiResponse<Map<String, dynamic>>> getTransactionStatistics() async {
    return await _orderService.getTransactionStatistics();
  }

  Future<ApiResponse<String>> downloadInvoicePdf(int orderId) async {
    return await _orderService.downloadInvoicePdf(orderId);
  }

  Future<ApiResponse<String>> downloadTransactionInvoicePdf(
      int transactionId) async {
    return await _orderService.downloadTransactionInvoicePdf(transactionId);
  }

  // Utility methods
  void logout() {
    _authService.logout();
  }

  bool isAuthenticated() {
    return _authService.isAuthenticated();
  }

  String? getAuthToken() {
    return _authService.getAuthToken();
  }

  void setAuthToken(String token) {
    _apiService.setAuthToken(token);
  }

  void dispose() {
    _apiService.dispose();
  }
}
