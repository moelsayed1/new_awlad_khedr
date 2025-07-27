import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/search/presentation/controllers/search_controller.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchQuery;
  final String? selectedCategory;

  const SearchResultsPage({
    super.key,
    required this.searchQuery,
    this.selectedCategory,
  });

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late final TextEditingController searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final categoryController = Provider.of<CategoryController>(context, listen: false);
    searchController = TextEditingController(text: widget.searchQuery);
    _scrollController = ScrollController();
    // Set initial search query and apply filter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryController.applySearchFilter(widget.searchQuery);
    });
    _scrollController.addListener(() {
      final controller = Provider.of<CategoryController>(context, listen: false);
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        if (controller.hasMoreProducts && !controller.isLoadingProducts) {
          controller.loadMoreProducts();
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryController = Provider.of<CategoryController>(context);
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
                  'نتائج البحث',
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
                onChanged: (query) {
                  categoryController.applySearchFilter(query);
                },
                onSubmitted: (query) {
                  categoryController.applySearchFilter(query);
                },
              ),
            ),
            //  SizedBox(height: 8.h),
            if (!categoryController.isListLoaded && categoryController.filteredProducts.isEmpty)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (categoryController.filteredProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'لا توجد نتائج للبحث',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: Stack(
                  children: [
                    RefreshIndicator(
                      onRefresh: () async {
                        if (categoryController.selectedCategory == 'الكل') {
                          await categoryController.fetchAllProducts();
                        } else {
                          await categoryController.fetchProductsByCategory();
                        }
                        categoryController.applySearchFilter(searchController.text);
                      },
                      backgroundColor: Colors.white,
                      child: ListView.separated(
                        controller: _scrollController,
                        itemCount: categoryController.filteredProducts.length + (categoryController.isLoadingProducts && categoryController.hasMoreProducts ? 1 : 0),
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) {
                          if (index == categoryController.filteredProducts.length && categoryController.isLoadingProducts && categoryController.hasMoreProducts) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final product = categoryController.filteredProducts[index];
                          final String quantityKey = product.productId?.toString() ?? product.productName ?? 'product_${index}';
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CartProductCard(
                                  item: {
                                    'product': product,
                                    'quantity': categoryController.productQuantities[quantityKey] ?? 0,
                                    'price': product.price ?? 0.0,
                                    'total_price': (product.price ?? 0.0) * (categoryController.productQuantities[quantityKey] ?? 0),
                                  },
                                  isRemoving: false,
                                  onIncrease: () async {
                                    final currentQuantity = categoryController.productQuantities[quantityKey] ?? 0;
                                    final newQuantity = currentQuantity + 1;
                                    categoryController.onQuantityChanged(quantityKey, newQuantity);
                                    categoryController.cart[product] = newQuantity;
                                    categoryController.safeNotifyListeners();
                                    await categoryController.addProductToCart(product, newQuantity);
                                    // CRITICAL FIX: Don't call syncProductQuantitiesWithCart() to avoid overriding local quantities
                                    // categoryController.syncProductQuantitiesWithCart();
                                  },
                                  onDecrease: () async {
                                    final currentQuantity = categoryController.productQuantities[quantityKey] ?? 0;
                                    final newQuantity = currentQuantity - 1;
                                    if (newQuantity > 0) {
                                      categoryController.onQuantityChanged(quantityKey, newQuantity);
                                      categoryController.cart[product] = newQuantity;
                                    } else {
                                      categoryController.onQuantityChanged(quantityKey, 0);
                                      categoryController.cart.remove(product);
                                    }
                                    categoryController.safeNotifyListeners();
                                    // CRITICAL FIX: Don't call syncProductQuantitiesWithCart() to avoid overriding local quantities
                                    // categoryController.syncProductQuantitiesWithCart();
                                  },
                                  onAddToCart: () async {
                                    final currentQuantity = categoryController.productQuantities[quantityKey] ?? 0;
                                    final newQuantity = currentQuantity + 1;
                                    categoryController.onQuantityChanged(quantityKey, newQuantity);
                                    categoryController.cart[product] = newQuantity;
                                    categoryController.safeNotifyListeners();
                                    await categoryController.addProductToCart(product, newQuantity);
                                    // CRITICAL FIX: Don't call syncProductQuantitiesWithCart() to avoid overriding local quantities
                                    // categoryController.syncProductQuantitiesWithCart();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (categoryController.isLoadingProducts && categoryController.filteredProducts.isEmpty)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
          ],
        ),
      ),
              floatingActionButton: categoryController.fetchedCartItems.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xffFC6E2A),
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
                        onClose: () => Navigator.pop(context),
                        onPaymentSuccess: () {
                          categoryController.clearCart();
                        },
                      );
                    },
                  ),
                );
              },
              label: Text(
                'السلة (${categoryController.fetchedCartItems.length})',
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