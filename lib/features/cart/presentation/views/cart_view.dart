import 'dart:async';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/cart/presentation/views/widgets/custom_button_cart.dart';
import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart'
    as top_rated;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:provider/provider.dart';

/// Logic class to separate business logic from UI
class CartViewLogic extends ChangeNotifier {
  final CategoryController controller;
  bool loading = true;
  final Set<int> removingItems = {};

  CartViewLogic(this.controller);

  Future<void> fetchCart() async {
    await controller.fetchCartFromApi();
    loading = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> get cartItems {
    final Map<int?, List<Map<String, dynamic>>> grouped = {};
    for (var item in controller.fetchedCartItems) {
      final product = item['product'];
      if (product == null) continue;
      final productId = product.productId;
      grouped.putIfAbsent(productId, () => []).add(item);
    }
    // For display, sum quantities and total_price, but keep a reference to all cart entries
    return grouped.entries.map((entry) {
      final items = entry.value;
      final first = items.first;
      final totalQuantity =
          items.fold<int>(0, (sum, i) => sum + (i['quantity'] as int));
      final totalPrice =
          items.fold<double>(0, (sum, i) => sum + (i['total_price'] as double));
      return {
        ...first,
        'quantity': totalQuantity,
        'total_price': totalPrice,
        'cart_entries': items, // keep all original cart entries
      };
    }).toList();
  }

  double get total => controller.fetchedCartTotal;

  // Improved debounce logic with better cancellation handling
  final Map<int, bool> _debounceCancelled = {};
  final Map<int, Timer> _debounceTimers = {};

  void _debounceAction(int cartId, Future<void> Function() action,
      {Duration duration = const Duration(milliseconds: 500)}) {
    // Cancel any existing debounce for this cartId
    _debounceCancelled[cartId] = true;
    _debounceTimers[cartId]?.cancel();

    // Create a new debounce
    _debounceCancelled[cartId] = false;
    _debounceTimers[cartId] = Timer(duration, () async {
      if (!(_debounceCancelled[cartId] ?? false)) {
        await action();
        _debounceTimers.remove(cartId);
        _debounceCancelled.remove(cartId);
      }
    });
  }

  Future<void> increaseQuantity(
      BuildContext context, Map<String, dynamic> item, int index) async {
    final cartEntries = item['cart_entries'] as List<Map<String, dynamic>>?;
    if (cartEntries == null || cartEntries.isEmpty) return;

    // Find the entry with the largest quantity (or just use the first)
    final cartEntry = cartEntries.reduce(
        (a, b) => (a['quantity'] as int) >= (b['quantity'] as int) ? a : b);
    final cartId = cartEntry['id'];
    final product = cartEntry['product'];
    final quantity = cartEntry['quantity'] as int;
    final newQuantity = quantity + 1;

    // Optimistic update
    cartEntry['quantity'] = newQuantity;
    notifyListeners();

    _debounceAction(cartId, () async {
      try {
        final success = await controller.updateCartItem(
          cartId: cartId,
          product: product,
          quantity: newQuantity,
        );
        if (!success) {
          // Revert on failure
          cartEntry['quantity'] = quantity;
          notifyListeners();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update item quantity.')),
            );
          }
        }
      } catch (e) {
        // Revert on error
        cartEntry['quantity'] = quantity;
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating item quantity.')),
          );
        }
      }
    });
  }

  Future<void> decreaseQuantity(
      BuildContext context, Map<String, dynamic> item, int index) async {
    final cartEntries = item['cart_entries'] as List<Map<String, dynamic>>?;
    if (cartEntries == null || cartEntries.isEmpty) return;

    // Find the entry with the largest quantity (or just use the first)
    final cartEntry = cartEntries.reduce(
        (a, b) => (a['quantity'] as int) >= (b['quantity'] as int) ? a : b);
    final cartId = cartEntry['id'];
    final product = cartEntry['product'];
    final quantity = cartEntry['quantity'] as int;
    final newQuantity = quantity - 1;

    // Check if already deleting this item
    if (controller.isCartItemDeleting(cartId)) {
      return;
    }

    // Optimistic update
    cartEntry['quantity'] = newQuantity;
    notifyListeners();

    _debounceAction(cartId, () async {
      try {
        bool success = true;
        if (newQuantity > 0) {
          success = await controller.updateCartItem(
            cartId: cartId,
            product: product,
            quantity: newQuantity,
          );
        } else {
          // Mark as removing to prevent overlapping operations
          removingItems.add(cartId);
          notifyListeners();

          success = await controller.deleteCartItem(cartId: cartId);

          if (success) {
            removingItems.remove(cartId);
            // Remove from local data immediately to prevent UI issues
            controller.fetchedCartItems
                .removeWhere((item) => item['id'] == cartId);
            notifyListeners();
          } else {
            removingItems.remove(cartId);
            // Revert on failure
            cartEntry['quantity'] = quantity;
            notifyListeners();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Failed to remove item from cart.')),
              );
            }
          }
        }

        if (!success && newQuantity > 0) {
          // Revert on failure for quantity updates
          cartEntry['quantity'] = quantity;
          notifyListeners();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update item quantity.')),
            );
          }
        }
      } catch (e) {
        // Revert on error
        cartEntry['quantity'] = quantity;
        removingItems.remove(cartId);
        notifyListeners();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error updating cart.')),
          );
        }
      }
    });
  }

  bool isRemoving(int cartId) => removingItems.contains(cartId);

  @override
  void dispose() {
    // Cancel all pending debounce timers
    for (var timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
    _debounceCancelled.clear();
    super.dispose();
  }
}

/// Reusable Product Card Widget for Cart
class CartProductCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isRemoving;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback? onAddToCart; // New callback for Add to Cart button

  const CartProductCard({
    Key? key,
    required this.item,
    required this.isRemoving,
    required this.onIncrease,
    required this.onDecrease,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = item['product'];
    final quantity = item['quantity'] as int;
    final price = item['price'] as double;
    final totalPrice = item['total_price'] as double;

    // Show Add to Cart button if quantity is 0, otherwise show quantity controls
    final bool showAddToCart = quantity == 0;

    return Stack(
      children: [
        Opacity(
          opacity: isRemoving ? 0.5 : 1.0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left side: Add to Cart button OR Quantity controls
                showAddToCart
                    ? _buildAddToCartButton()
                    : _buildQuantityControls(),
                SizedBox(width: 10.w),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        product.productName ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                        // Remove maxLines and overflow to allow full name display
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'سعر ${price.toStringAsFixed(0)} ج.م',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontFamily: baseFont,
                        ),
                      ),
                      if (!showAddToCart) ...[
                        SizedBox(height: 2.h),
                        Text(
                          'شرنك = $quantity × ${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                            fontFamily: baseFont,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'سعر الاجمالي ${totalPrice.toStringAsFixed(0)} ج.م',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.brown[700],
                            fontFamily: baseFont,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                // Product image (right)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    color: Colors.grey[100],
                    child: (product.imageUrl != null && product.imageUrl != '')
                        ? Image.network(
                            product.imageUrl,
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image,
                            size: 60.w, color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isRemoving)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return Container(
      width: 80.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: Color(0xffFC6E2A),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onAddToCart,
          child: Center(
            child: Text(
              'اضف للسلة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onIncrease,
          child: Icon(
            Icons.add,
            color: Color(0xffFC6E2A),
            size: 24.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 36.w,
          height: 36.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Color(0xffE0E0E0)),
          ),
          child: Text(
            item['quantity'].toString(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: baseFont,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: onDecrease,
          child: Icon(
            Icons.remove,
            color: Color(0xffC29500),
            size: 28,
          ),
        ),
      ],
    );
  }
}

class CartProductList extends StatelessWidget {
  final List<dynamic> products;
  final ScrollController? scrollController;
  final Map<String, int> productQuantities;
  final bool hasMoreProducts;
  final Function(dynamic product, int newQuantity) onQuantityChanged;
  final Future<bool> Function(dynamic product, int quantity) addProductToCart;

  const CartProductList({
    Key? key,
    required this.products,
    required this.productQuantities,
    required this.hasMoreProducts,
    required this.onQuantityChanged,
    required this.addProductToCart,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller from context if available
    final controller =
        context.findAncestorStateOfType<_CartViewPageState>()?.logic.controller;
    return ListView.separated(
      controller: scrollController,
      itemCount: products.length + (hasMoreProducts ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        if (index == products.length) {
          // Show loading indicator at the bottom
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final product = products[index];
        final String quantityKey = product.productId != null
            ? product.productId.toString()
            : 'product_${index}';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CartProductCard(
            item: {
              'product': product,
              'quantity': productQuantities[quantityKey] ?? 0,
              'price': product.price ?? 0.0,
              'total_price': (product.price ?? 0.0) *
                  (productQuantities[quantityKey] ?? 0),
            },
            isRemoving: false,
            onAddToCart: () async {
              final currentQuantity = productQuantities[quantityKey] ?? 0;
              final newQuantity = currentQuantity + 1;
              onQuantityChanged(product, newQuantity);
              final success = await addProductToCart(product, newQuantity);
              debugPrint('addProductToCart success: $success');
              if (success && controller != null) {
                await controller.fetchCartFromApi();
              }
            },
            onIncrease: () async {
              final currentQuantity = productQuantities[quantityKey] ?? 0;
              final newQuantity = currentQuantity + 1;
              onQuantityChanged(product, newQuantity);
              final success = await addProductToCart(product, newQuantity);
              debugPrint('addProductToCart success: $success');
              if (success && controller != null) {
                await controller.fetchCartFromApi();
              }
            },
            onDecrease: () async {
              final currentQuantity = productQuantities[quantityKey] ?? 0;
              final newQuantity = currentQuantity - 1;
              if (newQuantity > 0) {
                onQuantityChanged(product, newQuantity);
                final success = await addProductToCart(product, newQuantity);
                debugPrint('addProductToCart success: $success');
                if (success && controller != null) {
                  await controller.fetchCartFromApi();
                }
              } else {
                onQuantityChanged(product, 0);
                // Remove from local cart only - API call removed
              }
            },
          ),
        );
      },
    );
  }
}

class CartViewPage extends StatefulWidget {
  // No need to pass products/quantities; always use controller
  const CartViewPage(
      {super.key,
      required List<top_rated.Product> products,
      required List<int> quantities});

  @override
  State<CartViewPage> createState() => _CartViewPageState();
}

class _CartViewPageState extends State<CartViewPage> {
  late CartViewLogic logic;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<CategoryController>(context, listen: false);
    logic = CartViewLogic(controller);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await logic.fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes in logic
    return AnimatedBuilder(
      animation: logic,
      builder: (context, _) {
        final cartItems = logic.cartItems;
        return MainLayout(
          selectedIndex: 1,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'الاوردر',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Builder(
                  builder: (context) => IconButton(
                    icon: Image.asset(
                      AssetsData.drawerIcon,
                      height: 45,
                      width: 45,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
              centerTitle: true,
              titleSpacing: 0,
            ),
            drawer: const CustomDrawer(),
            body: logic.loading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.0.r),
                          child: (cartItems.isEmpty)
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_bag_outlined,
                                        size: 80.sp,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'لا توجد منتجات صالحة في السلة',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                          fontFamily: baseFont,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: cartItems.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 15.h),
                                  itemBuilder: (context, index) {
                                    // Reverse the index to show the most recently added items at the top
                                    final reversedIndex =
                                        cartItems.length - 1 - index;
                                    final item = cartItems[reversedIndex];
                                    return CartProductCard(
                                      item: item,
                                      isRemoving: logic.isRemoving(item['id']),
                                      onIncrease: () => logic.increaseQuantity(
                                          context, item, reversedIndex),
                                      onDecrease: () => logic.decreaseQuantity(
                                          context, item, reversedIndex),
                                    );
                                  },
                                ),
                        ),
                      ),
                      // Bottom Total Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, -3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'الحد الادني الاوردر 3000 جنيه لاستكمال الطلب',
                              style: TextStyle(
                                color: Colors.red,
                                fontFamily: baseFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\t${logic.total.toInt()} ج.م ',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontFamily: baseFont,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                Text(
                                  'الاجمالي',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontFamily: baseFont,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            // Order Now Button
                            CustomButtonCart(
                              count: logic.total,
                              onOrderConfirmed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Order placed!')),
                                );
                              },
                              products: cartItems
                                  .map((item) => item['product'])
                                  .toList(),
                              quantities: cartItems
                                  .map((item) => item['quantity'] as int)
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
