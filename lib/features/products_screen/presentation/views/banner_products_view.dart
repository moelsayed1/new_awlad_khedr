import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/products_screen/presentation/controllers/banner_products_controller.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';

import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
    final dynamic selectedProductObj = (widget.selectedProduct is Map<String, dynamic>)
        ? Product.fromJson(widget.selectedProduct as Map<String, dynamic>)
        : widget.selectedProduct;
    return ChangeNotifierProvider(
      create: (context) => BannerProductsController(
        CategoryRepository(),
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
    final controller = context.watch<BannerProductsController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            // Title on the right
            Positioned(
              right: 20, // Padding from the right edge
              top: 16,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  controller.categoryName ?? controller.brandName ?? 'المنتجات',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont,
                  ),
                ),
              ),
            ),
            // Back button and text on the left
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
                 //const SizedBox(width: 4),
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
                onChanged: controller.applySearchFilter,
              ),
            ),
            const SizedBox(height: 15),
            if (!controller.isListLoaded)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.displayedProducts.isEmpty)
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
                    await controller.fetchBannerProducts();
                  },
                  backgroundColor: Colors.white,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                        controller.loadNextPage();
                      }
                      return true;
                    },
                    child: ListView.separated(
                      itemCount: controller.displayedProducts.length + (controller.hasMoreProducts ? 1 : 0),
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        if (index == controller.displayedProducts.length) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
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

                        final product = controller.displayedProducts[index];
                        final String quantityKey = product.productId?.toString() ?? product.productName ?? 'product_${index}';
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              ProductItemCard(
                                product: product,
                                quantity: controller.productQuantities[quantityKey] ?? 0,
                                onQuantityChanged: (newQuantity) {
                                  controller.onQuantityChanged(quantityKey, newQuantity);
                                  if (newQuantity > 0) {
                                    controller.cart[product] = newQuantity;
                                  } else {
                                    controller.cart.remove(product);
                                  }
                                  controller.safeNotifyListeners();
                                },
                                onAddToCart: () {
                                  final currentQuantity = controller.productQuantities[quantityKey] ?? 0;
                                  final newQuantity = currentQuantity + 1;
                                  controller.onQuantityChanged(quantityKey, newQuantity);
                                  controller.cart[product] = newQuantity;
                                  controller.safeNotifyListeners();
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