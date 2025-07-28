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
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';

class BannerProductsPage extends StatefulWidget {
  final String? bannerTitle;
  final String? categoryName;
  final int? categoryId;
  final String? brandName;
  final int? brandId;
  final dynamic selectedProduct;

  const BannerProductsPage({
    super.key,
    this.bannerTitle,
    this.categoryName,
    this.categoryId,
    this.brandName,
    this.brandId,
    this.selectedProduct,
  });

  @override
  State<BannerProductsPage> createState() => _BannerProductsPageState();
}

class _BannerProductsPageState extends State<BannerProductsPage> {
  @override
  Widget build(BuildContext context) {
    // If selectedProduct is a Map, reconstruct as Product
    final dynamic selectedProductObj =
        (widget.selectedProduct is Map<String, dynamic>)
            ? Product.fromJson(widget.selectedProduct as Map<String, dynamic>)
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
      child: const _BannerProductsView(),
    );
  }
}

class _BannerProductsView extends StatefulWidget {
  const _BannerProductsView();

  @override
  State<_BannerProductsView> createState() => _BannerProductsViewState();
}

class _BannerProductsViewState extends State<_BannerProductsView> {
  late final TextEditingController searchController;

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
                child: Center(child: CircularProgressIndicator()),
              )
            else if (bannerController.displayedProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة لهذا البانر.',
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
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        darkOrange),
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
                        // Use productId as the key if available, for consistency
                        final String quantityKey = product.productId != null
                            ? product.productId.toString()
                            : 'product_${index}';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              Consumer<CategoryController>(
                                builder: (context, cartController, _) {
                                  return CartProductCard(
                                    item: {
                                      'product': product,
                                      'quantity': cartController
                                          .getCurrentQuantity(product),
                                      'price': product.price ?? 0.0,
                                      'total_price': (product.price ?? 0.0) *
                                          cartController
                                              .getCurrentQuantity(product),
                                    },
                                    isRemoving: false,
                                    onAddToCart: () async {
                                      final currentQuantity = cartController
                                          .getCurrentQuantity(product);
                                      final newQuantity = currentQuantity + 1;
                                      log('onAddToCart: key=$quantityKey, newQuantity=$newQuantity');

                                      // CRITICAL FIX: Update local state first
                                      cartController.updateLocalQuantity(
                                          product, newQuantity);

                                      final success = await cartController
                                          .addSingleProductToCart(
                                              product, newQuantity);

                                      if (!success) {
                                        // Revert on failure
                                        cartController.updateLocalQuantity(
                                            product, currentQuantity);
                                      } else {
                                        log('✅ Successfully added product: ${product.productName} - Quantity: $newQuantity');
                                      }
                                    },
                                    onIncrease: () async {
                                      final currentQuantity = cartController
                                          .getCurrentQuantity(product);
                                      final newQuantity = currentQuantity + 1;
                                      log('onIncrease: key=$quantityKey, newQuantity=$newQuantity');

                                      // CRITICAL FIX: Update local state first
                                      cartController.updateLocalQuantity(
                                          product, newQuantity);

                                      final success = await cartController
                                          .addSingleProductToCart(
                                              product, newQuantity);

                                      if (!success) {
                                        // Revert on failure
                                        cartController.updateLocalQuantity(
                                            product, currentQuantity);
                                      }
                                    },
                                    onDecrease: () async {
                                      final currentQuantity = cartController
                                          .getCurrentQuantity(product);
                                      final newQuantity = currentQuantity - 1;
                                      log('onDecrease: key=$quantityKey, newQuantity=$newQuantity');

                                      if (newQuantity > 0) {
                                        // CRITICAL FIX: Update local state first
                                        cartController.updateLocalQuantity(
                                            product, newQuantity);

                                        final success = await cartController
                                            .addSingleProductToCart(
                                                product, newQuantity);

                                        if (!success) {
                                          // Revert on failure
                                          cartController.updateLocalQuantity(
                                              product, currentQuantity);
                                        }
                                      } else {
                                        // CRITICAL FIX: Update local state first
                                        cartController.updateLocalQuantity(
                                            product, 0);

                                        final success = await cartController
                                            .removeProductFromCart(product);

                                        if (!success) {
                                          // Revert on failure
                                          cartController.updateLocalQuantity(
                                              product, currentQuantity);
                                        }
                                      }
                                    },
                                  );
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
      floatingActionButton: Consumer<CategoryController>(
        builder: (context, cartController, _) {
          return cartController.fetchedCartItems.isNotEmpty
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
                          return CartSheet(
                            onClose: () {
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                            onPaymentSuccess: () {
                              cartController.clearCart();
                            },
                          );
                        },
                      ),
                    );
                  },
                  label: Text(
                    'السلة (${cartController.fetchedCartItems.length})',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
