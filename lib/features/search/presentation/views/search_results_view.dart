import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/search/presentation/controllers/search_controller.dart';
import 'package:awlad_khedr/features/home/data/repositories/category_repository.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/most_requested/presentation/widgets/product_item_card.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';

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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductSearchController(
        CategoryRepository(),
        initialQuery: widget.searchQuery,
      )..initializeWithCategory(widget.selectedCategory),
      child: const _SearchResultsView(),
    );
  }
}

class _SearchResultsView extends StatefulWidget {
  const _SearchResultsView();

  @override
  State<_SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<_SearchResultsView> {
  late final TextEditingController searchController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProductSearchController>();
      searchController.text = controller.searchQuery;
      searchController.addListener(_onSearchChanged);
      _scrollController.addListener(_onScroll);
    });
  }

  void _onSearchChanged() {
    final controller = context.read<ProductSearchController>();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        controller.searchProducts(searchController.text);
      }
    });
  }

  void _onScroll() {
    final controller = context.read<ProductSearchController>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      if (controller.hasMore) {
        controller.fetchNextPage();
      }
    }
  }

  void _onCategorySelected(String category) {
    final controller = context.read<ProductSearchController>();
    controller.selectCategory(category);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductSearchController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            // Title on the right
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
                onChanged: controller.searchProducts,
                onCategorySelected: _onCategorySelected,
              ),
            ),
            const SizedBox(height: 15),
            // Show current filter info
            if (controller.selectedCategory.isNotEmpty || controller.searchQuery.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _buildFilterText(controller),
                        style: TextStyle(
                          fontFamily: baseFont,
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    if (controller.selectedCategory.isNotEmpty || controller.searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          controller.clearCategoryFilter();
                          searchController.clear();
                        },
                        child: Icon(Icons.clear, size: 16, color: Colors.grey[600]),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 15),
            if (!controller.isListLoaded)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (controller.pagedProducts.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        controller.selectedCategory.isNotEmpty ? Icons.category_outlined : Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.selectedCategory.isNotEmpty 
                            ? 'لا توجد منتجات في هذا الصنف'
                            : 'لا توجد نتائج للبحث',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18.sp,
                          fontFamily: baseFont,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.selectedCategory.isNotEmpty
                            ? 'جرب اختيار صنف آخر'
                            : 'جرب البحث بكلمات مختلفة',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14.sp,
                          fontFamily: baseFont,
                        ),
                      ),
                      if (controller.selectedCategory.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            controller.clearCategoryFilter();
                            searchController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkOrange,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'عرض جميع المنتجات',
                            style: TextStyle(
                              fontFamily: baseFont,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.searchProducts(controller.searchQuery);
                  },
                  backgroundColor: Colors.white,
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: controller.pagedProducts.length + (controller.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      if (index == controller.pagedProducts.length) {
                        // Show loading indicator at the end
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }
                      final product = controller.pagedProducts[index];
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

  String _buildFilterText(ProductSearchController controller) {
    List<String> filters = [];
    if (controller.selectedCategory.isNotEmpty) {
      filters.add('الصنف: ${controller.selectedCategory}');
    }
    if (controller.searchQuery.isNotEmpty) {
      filters.add('البحث: ${controller.searchQuery}');
    }
    return filters.join(' • ');
  }
} 