// For min function
import 'dart:async';
import 'dart:developer';

import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

// Ensure all necessary imports are correct and available in your project
import 'package:awlad_khedr/constant.dart'; // For APIConstant, baseFont
// Assuming authToken comes from here
// Contains TopRatedModel and Product
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart'; // For CustomDrawer
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart'; // For SearchWidget
import 'package:awlad_khedr/features/most_requested/presentation/widgets/category_filter_bar.dart';
// For ProductItemCard
import 'package:awlad_khedr/features/home/presentation/views/widgets/categories_app_bar.dart'; // For CategoriesAppBar
// For AppColors.primary
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/core/services/product_service.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;

// Helper function to split product name after two words
String splitAfterTwoWords(String? name) {
  if (name == null || name.trim().isEmpty) return '';
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length <= 2) return name;
  return '${words.take(2).join(' ')}\n${words.skip(2).join(' ')}';
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryController(
          CategoryRepository(ApiService(), ProductService())),
      child: const _CategoriesView(),
    );
  }
}

class _CategoriesView extends StatefulWidget {
  const _CategoriesView();

  @override
  State<_CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<_CategoriesView> {
  late final TextEditingController searchController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  
  // Add local state management like most_requested_views.dart
  final Map<String, int> _productQuantities = {};
  final Map<top_rated.Product, int> _cart = {};

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    // No need to manually initialize controller data here; it's done in the controller's constructor.
  }

  void _onScroll() async {
    final controller = context.read<CategoryController>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 10 &&
        !controller.isLoadingProducts &&
        controller.hasMoreProducts) {
      setState(() => _isLoadingMore = true);
      await controller.loadMoreProducts();
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showCustomDialog({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(icon, color: iconColor, size: 48),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: baseFont,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFC6E2A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'حسناً',
                      style: TextStyle(
                        fontFamily: baseFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CategoryController>();

    return Scaffold(
      appBar: const CategoriesAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        // REMOVE SingleChildScrollView here
        child: Column(
          // Use Column instead of SingleChildScrollView here
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchWidget(
                controller: searchController,
                onChanged: controller.applySearchFilter,
              ),
            ),
           //SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 50.h,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                child: CategoryFilterBar(
                  categories: controller.categories,
                  selectedCategory: controller.selectedCategory,
                  onCategorySelected: (category) {
                    controller.onCategorySelected(category);
                    searchController.clear();
                    if (category == 'الكل') {
                      controller.fetchAllProducts();
                    } else {
                      controller.fetchProductsByCategory();
                    }
                  },
                ),
              ),
            ),
            ),
            const SizedBox(height: 12),
            if (!controller.isListLoaded)
              const Expanded(
                // Use Expanded to allow CircularProgressIndicator to take available space
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                  ),
                ),
              )
            else if (controller.filteredProducts.isEmpty)
              Expanded(
                // Use Expanded
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة لهذه الفئة.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.sp,
                      fontFamily: baseFont,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (controller.selectedCategory == 'الكل') {
                      await controller.fetchAllProducts();
                    } else {
                      await controller.fetchProductsByCategory();
                    }
                  },
                  backgroundColor: Colors.white,
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: controller.filteredProducts.length +
                        (controller.hasMoreProducts ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      if (index == controller.filteredProducts.length) {
                        // Show loading indicator at the bottom
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                            ),
                          ),
                        );
                      }
                      final product = controller.filteredProducts[index];
                      final quantity = _productQuantities[product.productName!] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            CartProductCard(
                              item: {
                                'product': product,
                                'quantity': quantity,
                                'price': product.price is num
                                    ? (product.price as num).toDouble()
                                    : double.tryParse(
                                            product.price.toString()) ??
                                        0.0,
                                'total_price': (product.price is num
                                        ? (product.price as num).toDouble()
                                        : double.tryParse(
                                                product.price.toString()) ??
                                            0.0) *
                                    quantity,
                              },
                              isRemoving: false,
                              onIncrease: () async {
                                final currentQuantity = quantity;
                                final newQuantity = currentQuantity + 1;
                                log('onIncrease: product=${product.productName}, newQuantity=$newQuantity');

                                // CRITICAL FIX: Update local state first
                                setState(() {
                                  _productQuantities[product.productName!] = newQuantity;
                                  _cart[product] = newQuantity;
                                });

                                final success = await controller.addSingleProductToCart(
                                    product, newQuantity);

                                if (!success) {
                                  // Revert on failure
                                  setState(() {
                                    _productQuantities[product.productName!] = currentQuantity;
                                    if (currentQuantity == 0) {
                                      _cart.remove(product);
                                    } else {
                                      _cart[product] = currentQuantity;
                                    }
                                  });

                                  // Refresh cart data if operation failed
                                  await controller.fetchCartFromApi();
                                } else {
                                  log('✅ Successfully increased product: ${product.productName} - Quantity: $newQuantity');
                                }
                              },
                              onDecrease: () async {
                                final currentQuantity = quantity;
                                final newQuantity = currentQuantity - 1;
                                log('onDecrease: product=${product.productName}, newQuantity=$newQuantity');

                                if (newQuantity > 0) {
                                  // CRITICAL FIX: Update local state first
                                  setState(() {
                                    _productQuantities[product.productName!] = newQuantity;
                                    _cart[product] = newQuantity;
                                  });

                                  final success = await controller.addSingleProductToCart(
                                      product, newQuantity);

                                  if (!success) {
                                    // Revert on failure
                                    setState(() {
                                      _productQuantities[product.productName!] = currentQuantity;
                                      _cart[product] = currentQuantity;
                                    });

                                    // Refresh cart data if operation failed
                                    await controller.fetchCartFromApi();
                                  }
                                } else {
                                  // CRITICAL FIX: Update local state first
                                  setState(() {
                                    _productQuantities[product.productName!] = 0;
                                    _cart.remove(product);
                                  });

                                  final success = await controller.removeProductFromCart(product);

                                  if (!success) {
                                    // Revert on failure
                                    setState(() {
                                      _productQuantities[product.productName!] = currentQuantity;
                                      _cart[product] = currentQuantity;
                                    });

                                    // Refresh cart data if operation failed
                                    await controller.fetchCartFromApi();
                                  }
                                }
                              },
                              onAddToCart: () async {
                                final currentQuantity = quantity;
                                final newQuantity = currentQuantity + 1;
                                log('onAddToCart: product=${product.productName}, newQuantity=$newQuantity');

                                // CRITICAL FIX: Update local state first
                                setState(() {
                                  _productQuantities[product.productName!] = newQuantity;
                                  _cart[product] = newQuantity;
                                });

                                // Show success dialog immediately
                                _showCustomDialog(
                                  context: context,
                                  icon: Icons.check_circle,
                                  iconColor: const Color(0xffFC6E2A),
                                  message: 'تمت إضافة المنتج إلى السلة',
                                );

                                final success = await controller.addSingleProductToCart(
                                    product, newQuantity);

                                if (!success) {
                                  // Revert on failure
                                  setState(() {
                                    _productQuantities[product.productName!] = currentQuantity;
                                    if (currentQuantity == 0) {
                                      _cart.remove(product);
                                    } else {
                                      _cart[product] = currentQuantity;
                                    }
                                  });

                                  // Show error dialog
                                  _showCustomDialog(
                                    context: context,
                                    icon: Icons.error,
                                    iconColor: Colors.red,
                                    message: 'حدث خطأ أثناء إضافة المنتج للسلة',
                                  );

                                  // Refresh cart data if operation failed
                                  await controller.fetchCartFromApi();
                                } else {
                                  log('✅ Successfully added product: ${product.productName} - Quantity: $newQuantity');
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Color(0xffFC6E2A),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.33,
              minChildSize: 0.33,
              maxChildSize: 0.33,
              expand: false,
              builder: (context, scrollController) {
                      // Convert local cart to CartSheet format
                      final cartItems = _cart.entries.map((entry) {
                        final product = entry.key;
                        final quantity = entry.value;
                        final price = product.price is num
                            ? (product.price as num).toDouble()
                            : double.tryParse(product.price.toString()) ?? 0.0;
                        return {
                          'product': product,
                          'quantity': quantity,
                          'price': price,
                          'total_price': price * quantity,
                        };
                      }).toList();
                      
                      final cartTotal = _cart.entries.fold<double>(0.0, (sum, entry) {
                        final product = entry.key;
                        final quantity = entry.value;
                        final price = product.price is num
                            ? (product.price as num).toDouble()
                            : double.tryParse(product.price.toString()) ?? 0.0;
                        return sum + (price * quantity);
                      });
                      
                return CartSheet(
                  onClose: () => Navigator.pop(context),
                  onPaymentSuccess: () {
                          setState(() {
                            _cart.clear();
                            _productQuantities.clear();
                          });
                  },
                        cartItems: cartItems,
                        total: cartTotal,
                );
              },
            ),
          );
        },
        label: Text(
                'السلة (${_cart.length})',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            fontFamily: baseFont,
          ),
        ),
        icon: const Icon(Icons.shopping_cart, color: Colors.white),
      )
          : null,
    );
  }
}

extension on void Function(String message,
    {Object? error,
    int level,
    String name,
    int? sequenceNumber,
    StackTrace? stackTrace,
    DateTime? time,
    Zone? zone}) {
  void dev(String s) {}
}
