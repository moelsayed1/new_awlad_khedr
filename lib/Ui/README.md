# UI Layer Documentation

This directory contains the UI layer that integrates with the API layer to provide a complete user interface for the Awlad Khedr Flutter app.

## 📁 Directory Structure

```
lib/ui/
├── auth/
│   ├── auth_provider.dart      # Authentication state management
│   └── login_screen.dart       # Login screen with API integration
├── home/
│   ├── home_provider.dart      # Home screen state management
│   └── home_screen.dart        # Home screen with API integration
├── cart/
│   ├── cart_provider.dart      # Cart state management
│   └── cart_screen.dart        # Cart screen with API integration
├── order/
│   └── order_provider.dart     # Order state management
├── product/
│   └── product_provider.dart   # Product state management
├── ui_manager.dart             # Central UI management utility
└── README.md                  # This documentation
```

## 🏗️ Architecture Overview

The UI layer follows a **Provider Pattern** architecture with the following components:

### 1. **Providers** (State Management)
- **AuthProvider**: Manages authentication state, login, register, password reset
- **HomeProvider**: Manages home screen data, banners, categories
- **CartProvider**: Manages cart operations, add/remove items, checkout
- **OrderProvider**: Manages order history, order details, invoices
- **ProductProvider**: Manages product listings, search, filtering

### 2. **Screens** (UI Components)
- **LoginScreen**: Authentication interface with API integration
- **HomeScreen**: Main dashboard with products and categories
- **CartScreen**: Shopping cart with real-time updates

### 3. **UIManager** (Utility Class)
- Centralized provider management
- Common UI utilities (dialogs, loading states)
- Authentication helpers
- Error handling utilities

## 🔧 Integration with API Layer

The UI layer seamlessly integrates with the API layer (`lib/Api/`) through:

### Provider-API Integration
```dart
class AuthProvider extends ChangeNotifier {
  final ApiManager _apiManager = ApiManager();
  
  Future<bool> login(String username, String password) async {
    final response = await _apiManager.login(username, password);
    // Handle response and update state
  }
}
```

### Real-time State Updates
```dart
// Providers automatically update UI when API calls complete
await authProvider.login(username, password);
// UI automatically reflects loading states and results
```

## 🚀 Quick Start

### 1. Setup Providers in Main App

```dart
import 'package:awlad_khedr/ui/ui_manager.dart';

void main() {
  runApp(
    UIManager.withProviders(
      child: MyApp(),
    ),
  );
}
```

### 2. Use Providers in Screens

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return CircularProgressIndicator();
        }
        
        return Text('Welcome ${authProvider.user?.name}');
      },
    );
  }
}
```

### 3. Initialize App Data

```dart
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize app data
    UIManager.initializeApp(context);
  }
}
```

## 📱 Screen Examples

### Login Screen
```dart
class LoginScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // Login form
              TextField(controller: _usernameController),
              TextField(controller: _passwordController),
              
              // Login button
              ElevatedButton(
                onPressed: () async {
                  final success = await authProvider.login(
                    _usernameController.text,
                    _passwordController.text,
                  );
                  
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### Home Screen
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => homeProvider.loadHomeData(),
            child: ListView(
              children: [
                // Banners
                if (homeProvider.banners.isNotEmpty)
                  CarouselSlider(banners: homeProvider.banners),
                
                // Categories
                CategoriesSection(categories: homeProvider.categories),
                
                // Products
                ProductsGrid(products: homeProvider.products),
              ],
            ),
          ),
        );
      },
    );
  }
}
```

### Cart Screen
```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // Cart items
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.cartItems[index];
                    return CartItemWidget(
                      item: item,
                      onQuantityChanged: (quantity) {
                        cartProvider.updateCartItemQuantity(item.id!, quantity);
                      },
                    );
                  },
                ),
              ),
              
              // Total and checkout
              Container(
                child: Column(
                  children: [
                    Text('Total: ${cartProvider.totalAmount}'),
                    ElevatedButton(
                      onPressed: () => cartProvider.createOrder(),
                      child: Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## 🛠️ Utility Functions

### UIManager Utilities

```dart
// Show loading dialog
UIManager.showLoadingDialog(context, message: 'Loading...');

// Show error dialog
UIManager.showErrorDialog(context, 'Something went wrong');

// Show success dialog
UIManager.showSuccessDialog(context, 'Operation successful');

// Show confirmation dialog
final confirmed = await UIManager.showConfirmationDialog(
  context,
  'Confirm Action',
  'Are you sure you want to proceed?',
);

// Check authentication
if (UIManager.isAuthenticated(context)) {
  // User is logged in
}

// Get current user
final user = UIManager.getCurrentUser(context);

// Logout
UIManager.logout(context);
```

## 🔄 State Management Flow

### 1. **API Call Flow**
```
User Action → Provider Method → API Manager → API Service → Response → State Update → UI Update
```

### 2. **Loading States**
```dart
// Providers automatically manage loading states
if (provider.isLoading) {
  return CircularProgressIndicator();
}
```

### 3. **Error Handling**
```dart
// Providers automatically handle errors
if (provider.errorMessage != null) {
  return Text('Error: ${provider.errorMessage}');
}
```

## 📊 Data Flow Examples

### Authentication Flow
```dart
// 1. User enters credentials
// 2. Provider calls API
final success = await authProvider.login(username, password);

// 3. API responds
if (success) {
  // 4. State updates automatically
  // 5. UI reflects changes
  Navigator.pushReplacementNamed(context, '/home');
} else {
  // 6. Error state handled
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(authProvider.errorMessage!)),
  );
}
```

### Product Loading Flow
```dart
// 1. Screen initializes
@override
void initState() {
  super.initState();
  // 2. Load data
  Provider.of<HomeProvider>(context, listen: false).loadHomeData();
}

// 3. UI automatically updates when data loads
Consumer<HomeProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return CircularProgressIndicator();
    }
    
    return ListView.builder(
      itemCount: provider.products.length,
      itemBuilder: (context, index) {
        return ProductCard(product: provider.products[index]);
      },
    );
  },
)
```

## 🎨 UI Components

### Common Widgets
- **LoadingIndicator**: Consistent loading states
- **ErrorWidget**: Standardized error display
- **EmptyStateWidget**: Empty state handling
- **RetryButton**: Retry failed operations

### Responsive Design
- Uses `flutter_screenutil` for responsive sizing
- Supports different screen sizes
- RTL (Right-to-Left) text support for Arabic

### Theme Integration
- Consistent with app theme
- Dark/Light mode support
- Custom color schemes

## 🔒 Security Features

### Authentication
- Token-based authentication
- Automatic token refresh
- Secure logout
- Session management

### Data Protection
- Input validation
- Error message sanitization
- Secure API communication

## 📱 Platform Support

### Android
- Material Design components
- Android-specific optimizations
- Permission handling

### iOS
- Cupertino components where appropriate
- iOS-specific gestures
- Platform-specific styling

## 🧪 Testing

### Provider Testing
```dart
testWidgets('Login flow test', (WidgetTester tester) async {
  await tester.pumpWidget(
    UIManager.withProviders(
      child: LoginScreen(),
    ),
  );
  
  // Test login flow
  await tester.enterText(find.byType(TextField).first, 'username');
  await tester.enterText(find.byType(TextField).last, 'password');
  await tester.tap(find.text('Login'));
  await tester.pump();
  
  // Verify state changes
  expect(find.text('Welcome'), findsOneWidget);
});
```

### API Integration Testing
```dart
test('AuthProvider login test', () async {
  final provider = AuthProvider();
  
  final result = await provider.login('test', 'password');
  
  expect(result, isTrue);
  expect(provider.isAuthenticated, isTrue);
  expect(provider.user, isNotNull);
});
```

## 🚀 Performance Optimizations

### 1. **Lazy Loading**
- Load data only when needed
- Pagination for large lists
- Image caching

### 2. **State Optimization**
- Minimal rebuilds
- Efficient state updates
- Memory management

### 3. **API Optimization**
- Request caching
- Debounced search
- Batch operations

## 🔧 Configuration

### Environment Setup
```dart
// Configure API base URL
// lib/Api/api_constants.dart
const String baseUrl = 'https://your-api-domain.com/api';

// Configure app settings
// lib/constant.dart
const String appName = 'Awlad Khedr';
const String appVersion = '1.0.0';
```

### Provider Configuration
```dart
// Customize provider behavior
class CustomAuthProvider extends AuthProvider {
  @override
  Future<bool> login(String username, String password) async {
    // Custom login logic
    return super.login(username, password);
  }
}
```

## 📚 Additional Resources

### Dependencies
- `provider`: State management
- `flutter_screenutil`: Responsive design
- `go_router`: Navigation
- `shared_preferences`: Local storage

### Related Documentation
- [API Layer Documentation](../Api/README.md)
- [Core Components Documentation](../core/README.md)
- [Features Documentation](../features/README.md)

## 🤝 Contributing

### Code Style
- Follow Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Write unit tests for providers

### Adding New Features
1. Create provider in appropriate directory
2. Add UI components
3. Integrate with API layer
4. Update UIManager if needed
5. Add tests
6. Update documentation

### Bug Reports
- Include error messages
- Provide reproduction steps
- Attach relevant logs
- Specify device/platform

## 📄 License

This UI layer is part of the Awlad Khedr Flutter application and follows the same license as the main project.

---

**Note**: This UI layer is designed to work seamlessly with the API layer. Make sure to review the API documentation for complete integration details. 