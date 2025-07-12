# New Core Directory

This directory contains the core components that align with the API layer and UI folder, providing a centralized foundation for the Flutter application.

## Directory Structure

```
lib/new_core/
├── app_router.dart          # Application routing configuration
├── main_layout.dart         # Main layout with bottom navigation
├── custom_button.dart       # Custom button components
├── custom_text_field.dart   # Custom text field components
├── assets.dart             # Asset management and organization
├── service_locator.dart    # Dependency injection setup
├── models/
│   └── product_model.dart  # Product and category models
├── errors/
│   └── exception.dart      # Exception handling and error types
├── theme/
│   ├── app_colors.dart     # Color definitions and themes
│   └── app_theme.dart      # Complete app theme configuration
├── utils/
│   ├── constants.dart      # Application constants
│   └── helpers.dart        # Utility helper functions
└── README.md              # This documentation
```

## Components Overview

### 1. App Router (`app_router.dart`)
- **Purpose**: Centralized routing configuration using GoRouter
- **Features**:
  - Authentication routes (login, register, password reset)
  - Main app routes (home, cart, orders, profile)
  - Product routes (products, categories, details)
  - Payment routes (payment, success)
  - Provider integration with UIManager
  - Route protection and navigation logic

### 2. Main Layout (`main_layout.dart`)
- **Purpose**: Main application layout with bottom navigation
- **Features**:
  - Bottom navigation bar with cart badge
  - Arabic labels and RTL support
  - Provider integration for cart state
  - Navigation handling with GoRouter
  - Optional bottom navigation visibility

### 3. Custom Components

#### Custom Button (`custom_button.dart`)
- **Features**:
  - Loading state support
  - Multiple button types (Primary, Secondary)
  - Customizable styling (border radius, elevation, padding)
  - Arabic font integration
  - Disabled state handling

#### Custom Text Field (`custom_text_field.dart`)
- **Features**:
  - Input validation and formatting
  - Search and password field variants
  - RTL text direction support
  - Custom styling and theming
  - Error state handling

### 4. Asset Management (`assets.dart`)
- **Purpose**: Organized asset references and categorization
- **Features**:
  - Categorized asset constants (images, animations, fonts)
  - Asset validation and organization
  - Easy asset access and management

### 5. Service Locator (`service_locator.dart`)
- **Purpose**: Dependency injection using GetIt
- **Features**:
  - API service registration
  - UI provider registration
  - Singleton pattern implementation
  - Easy service access

### 6. Models (`models/product_model.dart`)
- **Purpose**: Data models for UI layer
- **Features**:
  - Product and category models
  - JSON serialization/deserialization
  - Copy with methods for immutability
  - API model integration

### 7. Error Handling (`errors/exception.dart`)
- **Purpose**: Centralized exception handling
- **Features**:
  - Custom exception types (Network, Auth, Validation, etc.)
  - Exception handler with Arabic error messages
  - Error categorization and handling

### 8. Theme System (`theme/`)
- **Purpose**: Complete theming system
- **Features**:
  - Color definitions and gradients
  - Material theme configuration
  - Light and dark theme support
  - Arabic font integration

### 9. Utilities (`utils/`)
- **Purpose**: Helper functions and constants
- **Features**:
  - Navigation helpers
  - UI helpers (snackbars, dialogs)
  - String formatting (prices, dates, phones)
  - Validation helpers
  - Device and keyboard helpers
  - File and color utilities

## Integration with API Layer

The new core components are designed to work seamlessly with the API layer:

1. **Service Integration**: Service locator registers API services for easy access
2. **Model Conversion**: Models can convert between API and UI representations
3. **Error Handling**: Centralized error handling for API responses
4. **Authentication**: Built-in auth state management
5. **Caching**: Helper functions for API response caching

## Integration with UI Layer

The new core components provide the foundation for the UI layer:

1. **Provider Integration**: Service locator manages UI providers
2. **Navigation**: App router handles all UI navigation
3. **Theming**: Consistent theming across all UI components
4. **Components**: Reusable UI components (buttons, text fields)
5. **Layout**: Main layout with bottom navigation

## Usage Examples

### Using the App Router
```dart
// Navigate to home screen
context.go(AppRouter.kHomeScreen);

// Navigate with parameters
context.go(AppRouter.kProductDetails, extra: {'productId': 123});
```

### Using Custom Components
```dart
// Primary button
PrimaryButton(
  text: 'تسجيل الدخول',
  onTap: () => handleLogin(),
  isLoading: isLoading,
);

// Search text field
SearchTextField(
  hintText: 'ابحث عن المنتجات...',
  onChanged: (value) => searchProducts(value),
);
```

### Using Service Locator
```dart
// Access API services
final authService = ServiceLocator.authService;
final productService = ServiceLocator.productService;

// Access UI providers
final authProvider = ServiceLocator.authProvider;
final cartProvider = ServiceLocator.cartProvider;
```

### Using Helpers
```dart
// Show snackbar
AppHelpers.showSnackBar(context, 'تم الإضافة بنجاح');

// Format price
final formattedPrice = AppHelpers.formatPrice(99.99);

// Validate email
final isValid = AppHelpers.isValidEmail('user@example.com');
```

## Best Practices

1. **Consistent Theming**: Always use AppColors and AppTheme for styling
2. **Error Handling**: Use the exception system for all error handling
3. **Navigation**: Use AppRouter for all navigation
4. **Service Access**: Use ServiceLocator for accessing services and providers
5. **Asset Management**: Use AssetsData for all asset references
6. **Helper Functions**: Use AppHelpers for common operations

## Migration from Old Core

When migrating from the old core directory:

1. **Replace imports**: Update import statements to use new core components
2. **Update navigation**: Use AppRouter instead of direct navigation
3. **Update theming**: Use AppColors and AppTheme instead of hardcoded values
4. **Update error handling**: Use the new exception system
5. **Update service access**: Use ServiceLocator for dependency injection

## Dependencies

The new core directory depends on:
- `go_router` for navigation
- `provider` for state management
- `get_it` for dependency injection
- `intl` for localization and formatting
- API layer components
- UI layer components

## Contributing

When adding new components to the new core:

1. Follow the existing naming conventions
2. Add proper documentation
3. Include usage examples
4. Update this README if needed
5. Ensure integration with API and UI layers 