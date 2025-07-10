class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://erp.khedrsons.com';

  // Authentication endpoints
  static const String login = '/api/login';
  static const String register = '/api/user/register';
  static const String updateUser = '/api/update/user';
  static const String sendOtp = '/api/send-otp';
  static const String resetPassword = '/api/reset-password';
  static const String sendVerificationEmail = '/api/send-verification-email';

  // Customer endpoints
  static const String customerData = '/api/customer';

  // Home endpoints
  static const String products = '/api/products';
  static const String banners = '/api/banners';
  static const String totalSold = '/api/products/totalSold';
  static const String categoryProducts = '/api/category/products';

  // Cart endpoints
  static const String cart = '/api/cart';
  static const String cartDelete = '/api/cart/delete';

  // Invoice/Orders endpoints
  static const String storeSell = '/api/sells/store';
  static const String orders = '/api/sells/orders';
  static const String transactions = '/api/sells/transactions';
  static const String orderDetails = '/api/orders';
  static const String orderInvoice = '/api/order-invoice';
  static const String transactionInvoice = '/api/transaction-invoice';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static const Map<String, String> multipartHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data',
  };
}
