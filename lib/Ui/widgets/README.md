# UI Widgets Documentation

This directory contains reusable UI widgets that integrate with the API layer and provide consistent design patterns across the Awlad Khedr Flutter app.

## 📁 Widget Structure

```
lib/ui/widgets/
├── carousel_slider.dart          # Banner carousel with indicators
├── search_widget.dart            # Search input field
├── category_home.dart            # Category display widget
├── most_requested_section.dart   # Most requested products section
├── product_card.dart             # Product display card
├── cart_item_widget.dart         # Cart item display
├── custom_button_cart.dart       # Custom cart button
├── order_card.dart              # Order display card
├── custom_drawer.dart           # Side navigation drawer
└── README.md                    # This documentation
```

## 🎯 Widget Overview

### **1. CarouselSlider**
**File**: `carousel_slider.dart`

Displays banner images in a carousel format with indicators.

```dart
CarouselWithIndicator(
  banners: bannerList,
)
```

**Features**:
- ✅ Auto-play functionality
- ✅ Touch navigation
- ✅ Indicator dots
- ✅ Error handling for images
- ✅ Fallback dummy banners

### **2. SearchWidget**
**File**: `search_widget.dart`

Custom search input field with Arabic RTL support.

```dart
SearchWidget(
  controller: searchController,
  onChanged: (query) => searchProducts(query),
  onSubmitted: (query) => performSearch(query),
  hintText: 'أبحث عن منتجاتك',
)
```

**Features**:
- ✅ RTL text direction
- ✅ Custom styling
- ✅ Search callbacks
- ✅ Placeholder text

### **3. HomeCategory**
**File**: `category_home.dart`

Displays product categories in a horizontal scrollable list.

```dart
HomeCategory(
  categories: categoryList,
  onCategoryTap: (category) => navigateToCategory(category),
)
```

**Features**:
- ✅ Horizontal scrolling
- ✅ Category images
- ✅ Tap callbacks
- ✅ Loading states

### **4. MostRequestedSection**
**File**: `most_requested_section.dart`

Displays most requested products in a horizontal scrollable section.

```dart
MostRequestedSection(
  products: productList,
  onProductTap: (product) => viewProduct(product),
  onAddToCart: (product, quantity) => addToCart(product, quantity),
)
```

**Features**:
- ✅ Product cards
- ✅ Add to cart functionality
- ✅ Product navigation
- ✅ Horizontal scrolling

### **5. ProductCard**
**File**: `product_card.dart`

Individual product display card with add to cart functionality.

```dart
ProductCard(
  product: product,
  onTap: () => viewProduct(product),
  onAddToCart: (quantity) => addToCart(product, quantity),
)
```

**Features**:
- ✅ Product image display
- ✅ Price formatting
- ✅ Add to cart button
- ✅ Error image handling

### **6. CartItemWidget**
**File**: `cart_item_widget.dart`

Displays individual cart items with quantity controls.

```dart
CartItemWidget(
  cartItem: cartItem,
  onQuantityChanged: (newQuantity) => updateQuantity(cartItem.id, newQuantity),
  onDelete: () => deleteCartItem(cartItem.id),
)
```

**Features**:
- ✅ Quantity controls (+/-)
- ✅ Price calculations
- ✅ Delete functionality
- ✅ Product image display

### **7. CustomButtonCart**
**File**: `custom_button_cart.dart`

Custom button widget for cart and checkout functionality.

```dart
CustomButtonCart(
  onTap: () => checkout(),
  text: 'إتمام الطلب',
  width: double.infinity,
  height: 50,
  color: Colors.black,
  isLoading: false,
  isEnabled: true,
)
```

**Features**:
- ✅ Loading states
- ✅ Disabled states
- ✅ Custom styling
- ✅ Responsive sizing

### **8. OrderCard**
**File**: `order_card.dart`

Displays order information with status and actions.

```dart
OrderCard(
  order: order,
  onViewDetails: () => viewOrderDetails(order),
  onCancel: () => cancelOrder(order.id),
)
```

**Features**:
- ✅ Order status display
- ✅ Status color coding
- ✅ Action buttons
- ✅ Date formatting

### **9. CustomDrawer**
**File**: `custom_drawer.dart`

Side navigation drawer with user profile and menu items.

```dart
CustomDrawer(
  user: currentUser,
  onLogout: () => logout(),
  onProfileTap: () => viewProfile(),
  onOrdersTap: () => viewOrders(),
)
```

**Features**:
- ✅ User profile display
- ✅ Navigation menu
- ✅ Logout confirmation
- ✅ Custom callbacks

## 🔧 API Integration

All widgets are designed to work seamlessly with the API layer:

### **Data Models**
```dart
// Product models
import '../../Api/models/product_models.dart' as api_models;

// Cart models
import '../../Api/models/cart_models.dart';

// Order models
import '../../Api/models/order_models.dart';

// Auth models
import '../../Api/models/auth_models.dart';
```

### **Provider Integration**
```dart
// Using with providers
Consumer<CartProvider>(
  builder: (context, cartProvider, child) {
    return CartItemWidget(
      cartItem: cartItem,
      onQuantityChanged: (quantity) {
        cartProvider.updateCartItemQuantity(cartItem.id!, quantity);
      },
    );
  },
)
```

## 🎨 Design System

### **Colors**
- Primary: `mainColor` (Yellow)
- Secondary: `kBrown` (Brown)
- Text: `Colors.black`
- Background: `Colors.white`
- Error: `Colors.red`
- Success: `Colors.green`

### **Typography**
- Font Family: `baseFont` (Tajawal)
- RTL Support: All text widgets support Arabic RTL
- Responsive Sizing: Using `flutter_screenutil`

### **Spacing**
- Consistent padding and margins
- Responsive sizing with `ScreenUtil`
- Proper spacing between elements

## 📱 Responsive Design

All widgets are responsive and work across different screen sizes:

```dart
// Responsive sizing
width: 160.w,
height: 120.h,
fontSize: 16.sp,
padding: EdgeInsets.all(8.w),
```

## 🔄 State Management

Widgets integrate with Provider pattern:

```dart
// Loading states
if (provider.isLoading) {
  return CircularProgressIndicator();
}

// Error states
if (provider.errorMessage != null) {
  return Text('Error: ${provider.errorMessage}');
}

// Success states
return WidgetContent();
```

## 🧪 Testing

### **Widget Testing**
```dart
testWidgets('ProductCard displays product info', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ProductCard(
        product: mockProduct,
        onTap: () {},
        onAddToCart: (quantity) {},
      ),
    ),
  );
  
  expect(find.text('Product Name'), findsOneWidget);
  expect(find.text('100 جنيه'), findsOneWidget);
});
```

### **Integration Testing**
```dart
testWidgets('CartItemWidget quantity controls work', (WidgetTester tester) async {
  int quantity = 1;
  
  await tester.pumpWidget(
    MaterialApp(
      home: CartItemWidget(
        cartItem: mockCartItem,
        onQuantityChanged: (newQuantity) {
          quantity = newQuantity;
        },
      ),
    ),
  );
  
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();
  
  expect(quantity, 2);
});
```

## 🚀 Usage Examples

### **Complete Home Screen**
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // Search
              SearchWidget(
                onChanged: (query) => homeProvider.searchProducts(query),
              ),
              
              // Banners
              if (homeProvider.banners.isNotEmpty)
                CarouselWithIndicator(banners: homeProvider.banners),
              
              // Categories
              HomeCategory(
                categories: homeProvider.categories,
                onCategoryTap: (category) => navigateToCategory(category),
              ),
              
              // Most Requested Products
              MostRequestedSection(
                products: homeProvider.products,
                onProductTap: (product) => viewProduct(product),
                onAddToCart: (product, quantity) => addToCart(product, quantity),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### **Complete Cart Screen**
```dart
class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          body: Column(
            children: [
              // Cart Items
              Expanded(
                child: ListView.builder(
                  itemCount: cartProvider.cartItems.length,
                  itemBuilder: (context, index) {
                    return CartItemWidget(
                      cartItem: cartProvider.cartItems[index],
                      onQuantityChanged: (quantity) {
                        cartProvider.updateCartItemQuantity(
                          cartProvider.cartItems[index].id!,
                          quantity,
                        );
                      },
                      onDelete: () {
                        cartProvider.deleteCartItem(
                          cartProvider.cartItems[index].id!,
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Checkout Button
              CustomButtonCart(
                onTap: () => cartProvider.createOrder(),
                text: 'إتمام الطلب',
                isLoading: cartProvider.isLoading,
                isEnabled: cartProvider.totalAmount >= 3000,
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## 🔧 Customization

### **Theme Customization**
```dart
// Custom colors
class CustomColors {
  static const Color primary = Color(0xFFFFD700);
  static const Color secondary = Color(0xFF8B4513);
}

// Custom text styles
class CustomTextStyles {
  static TextStyle get heading => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    fontFamily: baseFont,
  );
}
```

### **Widget Customization**
```dart
// Custom product card
class CustomProductCard extends ProductCard {
  CustomProductCard({
    required super.product,
    super.onTap,
    super.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Custom implementation
    return Container(
      // Custom styling
    );
  }
}
```

## 📚 Best Practices

### **1. Performance**
- Use `const` constructors where possible
- Implement proper `dispose()` methods
- Use `ListView.builder` for large lists
- Cache network images

### **2. Accessibility**
- Add semantic labels
- Support screen readers
- Provide alternative text for images
- Ensure proper contrast ratios

### **3. Error Handling**
- Always provide fallback UI
- Handle network errors gracefully
- Show user-friendly error messages
- Implement retry mechanisms

### **4. Code Organization**
- Keep widgets focused and single-purpose
- Extract reusable components
- Use consistent naming conventions
- Add proper documentation

## 🔄 Updates and Maintenance

### **Adding New Widgets**
1. Create widget file in appropriate directory
2. Follow naming conventions
3. Add proper documentation
4. Include usage examples
5. Add tests

### **Updating Existing Widgets**
1. Maintain backward compatibility
2. Update documentation
3. Test thoroughly
4. Update examples

### **Version Control**
- Use semantic versioning
- Document breaking changes
- Maintain changelog
- Tag releases

## 🤝 Contributing

### **Guidelines**
1. Follow existing code style
2. Add comprehensive tests
3. Update documentation
4. Test on multiple devices
5. Ensure accessibility compliance

### **Code Review**
- Review for performance issues
- Check accessibility compliance
- Verify API integration
- Test edge cases

---

**Note**: All widgets are designed to work seamlessly with the API layer and follow the established design patterns. For API integration details, refer to the main API documentation. 