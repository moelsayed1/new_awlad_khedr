import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/features/home/presentation/views/widgets/search_widget.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:awlad_khedr/features/home/presentation/widgets/cart_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;

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

  // Local state management
  final Map<String, int> _productQuantities = {};
  final Map<top_rated.Product, int> _cart = {};

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
    final categoryController = Provider.of<CategoryController>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            const Positioned(
              right: 20,
              top: 16,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'نتائج البحث',
                  style: TextStyle(
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
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                  ),
                ),
              )
            else if (categoryController.filteredProducts.isEmpty)
              const Expanded(
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
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                                ),
                              ),
                            );
                          }
                          final product = categoryController.filteredProducts[index];
                          final String quantityKey = product.productId?.toString() ?? product.productName ?? 'product_$index';
                          final quantity = _productQuantities[quantityKey] ?? 0;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                CartProductCard(
                                  item: {
                                    'product': product,
                                    'quantity': quantity,
                                    'price': product.price ?? 0.0,
                                    'total_price': (product.price ?? 0.0) * quantity,
                                  },
                                  isRemoving: false,
                                  onIncrease: () async {
                                    final currentQuantity = quantity;
                                    final newQuantity = currentQuantity + 1;
                                    
                                    // Update local state first
                                    setState(() {
                                      _productQuantities[quantityKey] = newQuantity;
                                      _cart[product] = newQuantity;
                                    });

                                    final success = await categoryController.addSingleProductToCart(product, newQuantity);
                                    
                                    if (!success) {
                                      // Revert on failure
                                      setState(() {
                                        _productQuantities[quantityKey] = currentQuantity;
                                        if (currentQuantity == 0) {
                                          _cart.remove(product);
                                        } else {
                                          _cart[product] = currentQuantity;
                                        }
                                      });
                                      
                                      // Refresh cart data if operation failed
                                      await categoryController.fetchCartFromApi();
                                    }
                                  },
                                  onDecrease: () async {
                                    final currentQuantity = quantity;
                                    final newQuantity = currentQuantity - 1;
                                    
                                    if (newQuantity > 0) {
                                      // Update local state first
                                      setState(() {
                                        _productQuantities[quantityKey] = newQuantity;
                                        _cart[product] = newQuantity;
                                      });

                                      final success = await categoryController.addSingleProductToCart(product, newQuantity);
                                      
                                      if (!success) {
                                        // Revert on failure
                                        setState(() {
                                          _productQuantities[quantityKey] = currentQuantity;
                                          _cart[product] = currentQuantity;
                                        });
                                        
                                        // Refresh cart data if operation failed
                                        await categoryController.fetchCartFromApi();
                                      }
                                    } else {
                                      // Update local state first
                                      setState(() {
                                        _productQuantities[quantityKey] = 0;
                                        _cart.remove(product);
                                      });

                                      final success = await categoryController.removeProductFromCart(product);
                                      
                                      if (!success) {
                                        // Revert on failure
                                        setState(() {
                                          _productQuantities[quantityKey] = currentQuantity;
                                          _cart[product] = currentQuantity;
                                        });
                                        
                                        // Refresh cart data if operation failed
                                        await categoryController.fetchCartFromApi();
                                      }
                                    }
                                  },
                                  onAddToCart: () async {
                                    final currentQuantity = quantity;
                                    final newQuantity = currentQuantity + 1;
                                    
                                    // Update local state first
                                    setState(() {
                                      _productQuantities[quantityKey] = newQuantity;
                                      _cart[product] = newQuantity;
                                    });

                                    // Show success dialog immediately
                                    _showCustomDialog(
                                      context: context,
                                      icon: Icons.check_circle,
                                      iconColor: const Color(0xffFC6E2A),
                                      message: 'تمت إضافة المنتج إلى السلة',
                                    );

                                    final success = await categoryController.addSingleProductToCart(product, newQuantity);
                                    
                                    if (!success) {
                                      // Revert on failure
                                      setState(() {
                                        _productQuantities[quantityKey] = currentQuantity;
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
                                      await categoryController.fetchCartFromApi();
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (categoryController.isLoadingProducts && categoryController.filteredProducts.isEmpty)
                      const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                ),
              ),
                  ],
                ),
              ),
          ],
        ),
      ),
              floatingActionButton: _cart.isNotEmpty
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
                          setState(() {
                            _cart.clear();
                            _productQuantities.clear();
                          });
                        },
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