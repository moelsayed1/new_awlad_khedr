# API Layer Documentation

This directory contains a complete API layer for the Flutter app, built based on the Postman collection provided. The API layer follows clean architecture principles and provides a robust foundation for handling all API communications.

## 📁 Directory Structure

```
lib/Api/
├── api_constants.dart          # API endpoints and constants
├── api_manager.dart            # Main API manager (entry point)
├── README.md                   # This documentation
├── example_usage.dart          # Usage examples
├── models/                     # Data models
│   ├── auth_models.dart        # Authentication models
│   ├── product_models.dart     # Product, banner, category models
│   ├── cart_models.dart        # Cart and cart item models
│   └── order_models.dart       # Order, transaction, invoice models
└── services/                   # API services
    ├── api_service.dart        # Base HTTP service
    ├── auth_service.dart       # Authentication service
    ├── product_service.dart    # Product service
    ├── cart_service.dart       # Cart service
    └── order_service.dart      # Order service
```

## 🚀 Quick Start

### 1. Initialize the API Manager

```dart
import 'package:your_app/Api/api_manager.dart';

final ApiManager apiManager = ApiManager();
```

### 2. Basic Authentication

```dart
// Login
final loginResponse = await apiManager.login('username', 'password');
if (loginResponse.success) {
  print('Login successful!');
  print('Token: ${loginResponse.token}');
}

// Check authentication status
bool isAuthenticated = apiManager.isAuthenticated();

// Logout
apiManager.logout();
```

### 3. Working with Products

```dart
// Get all products
final productsResponse = await apiManager.getAllProducts();
if (productsResponse.success) {
  for (final product in productsResponse.data ?? []) {
    print('Product: ${product.name} - ${product.price}');
  }
}

// Search products
final searchResponse = await apiManager.searchProducts('phone');

// Get banners
final bannersResponse = await apiManager.getAllBanners();
```

### 4. Cart Operations

```dart
// Get cart
final cartResponse = await apiManager.getCart();

// Add to cart
final addResponse = await apiManager.addToCart(
  product_id: 1,
  product_quantity: 2,
  price: 100.0,
);

// Update cart item
final updateResponse = await apiManager.updateCartItem(
  cartItemId: 1,
  product_id: 1,
  product_quantity: 3,
  price: 100.0,
);

// Delete cart item
await apiManager.deleteCartItem(1);
```

### 5. Order Management

```dart
// Create order from cart
final orderResponse = await apiManager.storeSell(mobile: true);

// Get all orders
final ordersResponse = await apiManager.getAllOrders();

// Get order details
final orderDetails = await apiManager.getOrderById(1234);

// Get order invoice
final invoiceResponse = await apiManager.getOrderInvoice(1234);
```

## 📋 API Endpoints Covered

### Authentication
- `POST /api/login` - User login
- `POST /api/user/register` - User registration
- `POST /api/update/user` - Update user data
- `POST /api/send-otp` - Send OTP
- `POST /api/reset-password` - Reset password
- `POST /api/send-verification-email` - Send verification email
- `GET /api/customer` - Get customer data

### Products & Home
- `GET /api/products` - Get all products
- `GET /api/banners` - Get all banners
- `GET /api/products/totalSold` - Get total sold
- `GET /api/category/products` - Get category products

### Cart
- `GET /api/cart` - Get cart items
- `POST /api/cart` - Add to cart
- `POST /api/cart/{id}` - Update cart item
- `POST /api/cart/delete/{id}` - Delete cart item

### Orders & Invoices
- `POST /api/sells/store` - Create order
- `GET /api/sells/orders` - Get all orders
- `GET /api/sells/transactions` - Get all transactions
- `GET /api/orders/{id}` - Get order details
- `GET /api/order-invoice/{id}` - Get order invoice
- `GET /api/transaction-invoice/{id}` - Get transaction invoice

## 🔧 Features

### ✅ Complete Model Coverage
- **Request Models**: All API requests are properly modeled
- **Response Models**: All API responses are properly typed
- **Data Models**: Complete data structures for all entities

### ✅ Error Handling
- Comprehensive error handling for network issues
- Proper HTTP status code handling
- User-friendly error messages

### ✅ Authentication
- Bearer token authentication
- Automatic token management
- Session state management

### ✅ File Upload Support
- Multipart form data support
- File upload for registration
- Image handling capabilities

### ✅ Type Safety
- Strongly typed models
- Null safety compliance
- Proper JSON serialization/deserialization

### ✅ Singleton Pattern
- Efficient resource management
- Single instance across the app
- Memory optimization

## 🛠️ Usage Examples

### Registration with File Upload

```dart
final registerResponse = await apiManager.register(
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
```

### Complete Shopping Workflow

```dart
// 1. Login
final loginResponse = await apiManager.login('username', 'password');

// 2. Get products
final productsResponse = await apiManager.getAllProducts();

// 3. Add to cart
if (productsResponse.data!.isNotEmpty) {
  final product = productsResponse.data!.first;
  await apiManager.addToCart(
    product_id: product.id!,
    product_quantity: 1,
    price: product.price!,
  );
}

// 4. Get cart
final cartResponse = await apiManager.getCart();

// 5. Create order
final orderResponse = await apiManager.storeSell(mobile: true);

// 6. Get order invoice
if (orderResponse.success) {
  final invoiceResponse = await apiManager.getOrderInvoice(orderResponse.data!.id!);
}
```

## 🔒 Security Features

- **Token Management**: Automatic bearer token handling
- **Secure Headers**: Proper content-type and authorization headers
- **Error Handling**: Secure error message handling
- **File Upload**: Secure multipart form data handling

## 📱 Integration with Flutter

### Provider Integration

```dart
class AuthProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();
  
  Future<bool> login(String username, String password) async {
    try {
      final response = await _apiManager.login(username, password);
      if (response.success) {
        // Update UI state
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
```

### Bloc Integration

```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiManager _apiManager = ApiManager();
  
  Future<void> loadProducts() async {
    try {
      final response = await _apiManager.getAllProducts();
      emit(ProductsLoaded(response.data ?? []));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
```

## 🧪 Testing

The API layer is designed to be easily testable:

```dart
// Mock API responses for testing
class MockApiManager extends ApiManager {
  @override
  Future<LoginResponse> login(String username, String password) async {
    // Return mock data for testing
    return LoginResponse(
      success: true,
      token: 'mock_token',
      user: UserData(id: 1, first_name: 'Test User'),
    );
  }
}
```

## 📦 Dependencies

Make sure to add the following dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  # Add other dependencies as needed
```

## 🚨 Important Notes

1. **Base URL**: Update the base URL in `api_constants.dart` if needed
2. **Error Handling**: Always wrap API calls in try-catch blocks
3. **Authentication**: The API manager automatically handles token management
4. **File Uploads**: Use proper file paths for image uploads
5. **Memory Management**: Call `dispose()` when the app is closed

## 🤝 Contributing

When adding new API endpoints:

1. Add the endpoint to `api_constants.dart`
2. Create appropriate models in the `models/` directory
3. Add service methods in the appropriate service file
4. Update the `ApiManager` with convenience methods
5. Add usage examples to `example_usage.dart`

## 📞 Support

For questions or issues with the API layer, please refer to the example usage file or create an issue in the project repository. 