// For min function
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
      create: (context) => CategoryController(CategoryRepository()),
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

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    // No need to manually initialize controller data here; it's done in the controller's constructor.
  }

  @override
  void dispose() {
    searchController.dispose();
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
                    itemCount: controller.filteredProducts.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final product = controller.filteredProducts[index];
                      final String quantityKey = product.productId?.toString() ?? product.productName ?? 'product_${index}';
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