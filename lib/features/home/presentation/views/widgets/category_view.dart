// For min function
import 'dart:async';
import 'dart:developer';

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
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart'; // For ProductItemCard
import 'package:awlad_khedr/features/home/presentation/views/widgets/categories_app_bar.dart'; // For CategoriesAppBar
// For AppColors.primary
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/core/services/product_service.dart';

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
      create: (context) => CategoryController(CategoryRepository(ApiService(), ProductService())),
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

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    // No need to manually initialize controller data here; it's done in the controller's constructor.
  }

  void _onScroll() async {
    final controller = context.read<CategoryController>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 &&
        controller.selectedCategory == 'الكل' &&
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

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CategoryController>();

    return Scaffold(
      appBar: const CategoriesAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        // REMOVE SingleChildScrollView here
        child: Column( // Use Column instead of SingleChildScrollView here
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
            const SizedBox(height: 15),
            if (!controller.isListLoaded)
              const Expanded( // Use Expanded to allow CircularProgressIndicator to take available space
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.filteredProducts.isEmpty)
              Expanded( // Use Expanded
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
                    itemCount: controller.filteredProducts.length + (controller.hasMoreProducts ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      if (index == controller.filteredProducts.length) {
                        // Show loading indicator at the bottom
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final product = controller.filteredProducts[index];
                      final String quantityKey = product.productId != null ? product.productId.toString() : 'product_${index}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            ProductItemCard(
                              product: product,
                              // Pass a custom productTitleBuilder to ProductItemCard if supported
                              // Otherwise, you may need to modify ProductItemCard to accept a title string
                              // Here, we assume ProductItemCard has a 'productTitle' or similar parameter
                              quantity: controller.productQuantities[quantityKey] ?? 0,
                              onQuantityChanged: (newQuantity) {
                                log.dev('onQuantityChanged: key=$quantityKey, newQuantity=$newQuantity');
                                controller.onQuantityChanged(quantityKey, newQuantity);
                                if (newQuantity > 0) {
                                  controller.cart[product] = newQuantity;
                                } else {
                                  controller.cart.remove(product);
                                }
                                controller.safeNotifyListeners();
                              },
                              onAddToCart: () async {
                                final currentQuantity = controller.productQuantities[quantityKey] ?? 0;
                                final newQuantity = currentQuantity + 1;
                                print('onAddToCart: key=$quantityKey, newQuantity=$newQuantity');
                                // Optimistically update UI first
                                controller.onQuantityChanged(quantityKey, newQuantity);
                                controller.cart[product] = newQuantity;
                                controller.safeNotifyListeners();
                                // Then sync with backend
                                await controller.addProductToCart(product, newQuantity);
                              },
                              // If ProductItemCard supports a custom title, pass it here:
                              // productTitle: splitAfterTwoWords(product.productName),
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
      floatingActionButton: controller.cart.isNotEmpty
          ? FloatingActionButton.extended(
        backgroundColor: Colors.orange,
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
                return CartSheet(
                  cart: controller.cart,
                  total: controller.cartTotal,
                  onClose: () => Navigator.pop(context),
                  onPaymentSuccess: () {
                    controller.clearCart();
                  },
                );
              },
            ),
          );
        },
        label: Text(
          'السلة (${controller.cart.length})',
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

extension on void Function(String message, {Object? error, int level, String name, int? sequenceNumber, StackTrace? stackTrace, DateTime? time, Zone? zone}) {
  void dev(String s) {}
}