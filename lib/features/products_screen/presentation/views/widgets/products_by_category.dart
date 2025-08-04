import 'dart:convert';
import 'dart:developer';
import 'package:awlad_khedr/features/products_screen/model/product_by_category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../constant.dart';
import '../../../../../main.dart';

import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:awlad_khedr/features/cart/services/cart_api_service.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart'
    as top_rated;
import 'dart:developer';

class ProductItemByCategory extends StatefulWidget {
  final int selectedCategoryId; // Receive selectedCategoryId

  const ProductItemByCategory({super.key, required this.selectedCategoryId});

  @override
  ProductItemByCategoryState createState() => ProductItemByCategoryState();
}

class ProductItemByCategoryState extends State<ProductItemByCategory> {
  ProductByCategoryModel? productByCategoryModel;
  bool isProductsLoaded = false;
  bool isLoadingMore = false;
  bool hasMoreProducts = true;

  // Pagination variables
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  int currentPage = 0;
  static const int productsPerPage = 10;
  int _lastRefreshTime = 0;

  // Cart variables
  final Map<String, int> productQuantities = {};
  final Map<top_rated.Product, int> cart = {};

  @override
  void didUpdateWidget(ProductItemByCategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if this is a refresh trigger
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - _lastRefreshTime > 100) {
      // Small delay to avoid multiple refreshes
      _lastRefreshTime = currentTime;
      refreshData();
    }
  }

  Future<void> refreshData() async {
    // Reset pagination and reload all products
    setState(() {
      displayedProducts.clear();
      currentPage = 0;
      hasMoreProducts = true;
    });

    // Reload all products from API
    await GetAllProductsByCategory();
  }

  Future<void> GetAllProductsByCategory() async {
    Uri uriToSend = Uri.parse(APIConstant.GET_ALL_PRODUCTS_BY_CATEGORY);
    final response = await http
        .get(uriToSend, headers: {"Authorization": "Bearer $authToken"});
    if (response.statusCode == 200) {
      productByCategoryModel =
          ProductByCategoryModel.fromJson(jsonDecode(response.body));

      // Get products for the selected category
      allProducts.clear();
      final selectedCategory = productByCategoryModel?.categories.firstWhere(
          (category) => category.categoryId == widget.selectedCategoryId,
          orElse: () => Category(
              categoryId: widget.selectedCategoryId,
              categoryName: '',
              categoryImage: '',
              products: [],
              subCategories: []));

      allProducts = selectedCategory?.products ?? [];

      // Load first page
      loadNextPage();
    }
    setState(() {
      isProductsLoaded = true;
    });
  }

  void loadNextPage() {
    if (isLoadingMore || !hasMoreProducts) return;

    setState(() {
      isLoadingMore = true;
    });

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final startIndex = currentPage * productsPerPage;
      final endIndex = startIndex + productsPerPage;

      if (startIndex < allProducts.length) {
        final newProducts = allProducts.sublist(startIndex,
            endIndex > allProducts.length ? allProducts.length : endIndex);

        setState(() {
          displayedProducts.addAll(newProducts);
          currentPage++;
          isLoadingMore = false;
          hasMoreProducts = endIndex < allProducts.length;
        });
      } else {
        setState(() {
          isLoadingMore = false;
          hasMoreProducts = false;
        });
      }
    });
  }

  @override
  void initState() {
    GetAllProductsByCategory();
    super.initState();
  }

  // Helper methods for cart functionality
  void onQuantityChanged(String productKey, int newQuantity) {
    setState(() {
      productQuantities[productKey] = newQuantity;
    });
  }

  void updateCartItemQuantity(top_rated.Product product, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        cart[product] = newQuantity;
      } else {
        cart.remove(product);
      }
    });
  }

  void removeFromCart(top_rated.Product product) {
    setState(() {
      cart.remove(product);
    });
  }

  // Convert Product to top_rated.Product
  top_rated.Product convertToTopRatedProduct(Product product) {
    return top_rated.Product(
      productId: product.productId,
      productName: product.productName,
      price: double.tryParse(product.productPrice ?? '0'),
      imageUrl: product.imageUrl,
      minimumSoldQuantity: product.minimumSoldQuantity?.toString(),
      qtyAvailable: product.qtyAvailable?.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isProductsLoaded
          ? displayedProducts.isNotEmpty
              ? Directionality(
                  textDirection: TextDirection.rtl,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        // User reached the bottom, load more products
                        loadNextPage();
                      }
                      return true;
                    },
                    child: ListView.separated(
                        itemCount: displayedProducts.length +
                            (hasMoreProducts ? 1 : 0),
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const SizedBox(
                              height: 15,
                            ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          // Show loading indicator at the bottom
                          if (index == displayedProducts.length) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                                                        child: const CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            darkOrange),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'جاري تحميل المزيد من المنتجات...',
                                    style: TextStyle(
                                      color: darkOrange,
                                      fontSize: 14,
                                      fontFamily: baseFont,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final product = displayedProducts[index];
                          final topRatedProduct =
                              convertToTopRatedProduct(product);
                          final String quantityKey =
                              product.productId?.toString() ??
                                  product.productName ??
                                  'product_${index}';

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CartProductCard(
                                  item: {
                                    'product': topRatedProduct,
                                    'quantity':
                                        productQuantities[quantityKey] ?? 0,
                                    'price': topRatedProduct.price ?? 0.0,
                                    'total_price': (topRatedProduct.price ??
                                            0.0) *
                                        (productQuantities[quantityKey] ?? 0),
                                  },
                                  isRemoving: false,
                                  onAddToCart: () async {
                                    final controller =
                                        Provider.of<CategoryController>(context,
                                            listen: false);
                                    final currentQuantity = controller
                                        .getCurrentQuantity(topRatedProduct);
                                    final newQuantity = currentQuantity + 1;

                                    // CRITICAL FIX: Update local state first
                                    controller.updateLocalQuantity(
                                        topRatedProduct, newQuantity);
                                    onQuantityChanged(quantityKey, newQuantity);
                                    updateCartItemQuantity(
                                        topRatedProduct, newQuantity);

                                    // Use CategoryController for single product addition
                                    final success =
                                        await controller.addSingleProductToCart(
                                            topRatedProduct, newQuantity);

                                    if (!success) {
                                      // Revert on failure
                                      controller.updateLocalQuantity(
                                          topRatedProduct, currentQuantity);
                                      onQuantityChanged(
                                          quantityKey, currentQuantity);
                                      updateCartItemQuantity(
                                          topRatedProduct, currentQuantity);
                                    } else {
                                      // CRITICAL FIX: Log success for debugging
                                      log('✅ Successfully added product: ${topRatedProduct.productName} - Quantity: $newQuantity');
                                    }
                                  },
                                  onIncrease: () async {
                                    final controller =
                                        Provider.of<CategoryController>(context,
                                            listen: false);
                                    final currentQuantity = controller
                                        .getCurrentQuantity(topRatedProduct);
                                    final newQuantity = currentQuantity + 1;

                                    // CRITICAL FIX: Update local state first
                                    controller.updateLocalQuantity(
                                        topRatedProduct, newQuantity);
                                    onQuantityChanged(quantityKey, newQuantity);
                                    updateCartItemQuantity(
                                        topRatedProduct, newQuantity);

                                    // Use CategoryController for single product update
                                    final success =
                                        await controller.addSingleProductToCart(
                                            topRatedProduct, newQuantity);

                                    if (!success) {
                                      // Revert on failure
                                      controller.updateLocalQuantity(
                                          topRatedProduct, currentQuantity);
                                      onQuantityChanged(
                                          quantityKey, currentQuantity);
                                      updateCartItemQuantity(
                                          topRatedProduct, currentQuantity);
                                    }
                                  },
                                  onDecrease: () async {
                                    final controller =
                                        Provider.of<CategoryController>(context,
                                            listen: false);
                                    final currentQuantity = controller
                                        .getCurrentQuantity(topRatedProduct);
                                    final newQuantity = currentQuantity - 1;

                                    if (newQuantity > 0) {
                                      // CRITICAL FIX: Update local state first
                                      controller.updateLocalQuantity(
                                          topRatedProduct, newQuantity);
                                      onQuantityChanged(
                                          quantityKey, newQuantity);
                                      updateCartItemQuantity(
                                          topRatedProduct, newQuantity);

                                      // Use CategoryController for single product update
                                      final success = await controller
                                          .addSingleProductToCart(
                                              topRatedProduct, newQuantity);

                                      if (!success) {
                                        // Revert on failure
                                        controller.updateLocalQuantity(
                                            topRatedProduct, currentQuantity);
                                        onQuantityChanged(
                                            quantityKey, currentQuantity);
                                        updateCartItemQuantity(
                                            topRatedProduct, currentQuantity);
                                      }
                                    } else {
                                      // CRITICAL FIX: Update local state first
                                      controller.updateLocalQuantity(
                                          topRatedProduct, 0);
                                      onQuantityChanged(quantityKey, 0);
                                      removeFromCart(topRatedProduct);

                                      // Use CategoryController for product removal
                                      final success = await controller
                                          .removeProductFromCart(
                                              topRatedProduct);

                                      if (!success) {
                                        // Revert on failure
                                        controller.updateLocalQuantity(
                                            topRatedProduct, currentQuantity);
                                        onQuantityChanged(
                                            quantityKey, currentQuantity);
                                        updateCartItemQuantity(
                                            topRatedProduct, currentQuantity);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                )
              : const Directionality(
                  textDirection: TextDirection.rtl,
                  child: Center(
                      child: Text(
                    'لا توجد منتجات لهذه الفئة',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black),
                  )),
                )
                        : const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                  ),
                ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xffFC6E2A),
              onPressed: () async {
                // Navigate to cart page directly since products are already added
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CartViewPage(),
                  ),
                );
              },
              label: Text(
                'السلة (${cart.length})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
