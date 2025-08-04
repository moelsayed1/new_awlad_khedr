import 'dart:developer';

import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/core/services/product_service.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:awlad_khedr/features/products_screen/presentation/controllers/banner_products_controller.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';

import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;

class CategoryProductsPage extends StatefulWidget {
  final String? bannerTitle;
  final String? categoryName;
  final int? categoryId;
  final String? brandName;
  final int? brandId;
  final dynamic selectedProduct;

  const CategoryProductsPage({
    super.key,
    this.bannerTitle,
    this.categoryName,
    this.categoryId,
    this.brandName,
    this.brandId,
    this.selectedProduct,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  Widget build(BuildContext context) {
    // If selectedProduct is a Map, reconstruct as Product
    final dynamic selectedProductObj =
        (widget.selectedProduct is Map<String, dynamic>)
            ? top_rated.Product.fromJson(widget.selectedProduct as Map<String, dynamic>)
            : widget.selectedProduct;
    return ChangeNotifierProvider(
      create: (context) => BannerProductsController(
        CategoryRepository(ApiService(), ProductService()),
        categoryId: widget.categoryId,
        brandId: widget.brandId,
        categoryName: widget.categoryName,
        brandName: widget.brandName,
        selectedProduct: selectedProductObj,
      ),
      child: const _CategoryProductsView(),
    );
  }
}

class _CategoryProductsView extends StatefulWidget {
  const _CategoryProductsView();

  @override
  State<_CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<_CategoryProductsView> {
  late final TextEditingController searchController;
  
  // Add local state management like most_requested_views.dart
  final Map<String, int> _productQuantities = {};
  final Map<top_rated.Product, int> _cart = {};

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
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
    final bannerController = context.watch<BannerProductsController>();
    final cartController = context.watch<CategoryController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 16,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  bannerController.categoryName ??
                      bannerController.brandName ??
                      'المنتجات',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 16,
              bottom: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      AssetsData.back,
                      height: 32,
                      width: 32,
                    ),
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                  const Text(
                    'للرجوع',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchWidget(
                controller: searchController,
                onChanged: bannerController.applySearchFilter,
              ),
            ),
            if (!bannerController.isListLoaded)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                  ),
                ),
              )
            else if (bannerController.displayedProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة لهذا الصنف.',
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
                    await bannerController.fetchBannerProducts();
                  },
                  backgroundColor: Colors.white,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent) {
                        bannerController.loadNextPage();
                      }
                      return true;
                    },
                    child: ListView.separated(
                      itemCount: bannerController.displayedProducts.length +
                          (bannerController.hasMoreProducts ? 1 : 0),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        if (index ==
                            bannerController.displayedProducts.length) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                                                      child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                                      strokeWidth: 2.0,
                                  ),
                                ),
                                SizedBox(width: 12),
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

                        final product =
                            bannerController.displayedProducts[index];
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

                                  final success = await cartController.addSingleProductToCart(
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
                                    await cartController.fetchCartFromApi();
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

                                    final success = await cartController.addSingleProductToCart(
                                        product, newQuantity);

                                    if (!success) {
                                      // Revert on failure
                                      setState(() {
                                        _productQuantities[product.productName!] = currentQuantity;
                                        _cart[product] = currentQuantity;
                                      });

                                      // Refresh cart data if operation failed
                                      await cartController.fetchCartFromApi();
                                    }
                                  } else {
                                    // CRITICAL FIX: Update local state first
                                    setState(() {
                                      _productQuantities[product.productName!] = 0;
                                      _cart.remove(product);
                                    });

                                    final success = await cartController.removeProductFromCart(product);

                                    if (!success) {
                                      // Revert on failure
                                      setState(() {
                                        _productQuantities[product.productName!] = currentQuantity;
                                        _cart[product] = currentQuantity;
                                      });

                                      // Refresh cart data if operation failed
                                      await cartController.fetchCartFromApi();
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

                                  final success = await cartController.addSingleProductToCart(
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
                                    await cartController.fetchCartFromApi();
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
              ),
          ],
        ),
      ),
      floatingActionButton: _cart.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: Color(0xffFC6E2A),
              onPressed: () {
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