import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/constant.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String? categoryName;
  const CategoryProductsScreen({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CategoryController>(context);
    final products = controller.filteredProducts;
    final isLoading = controller.isLoadingProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName ?? '', style: TextStyle(fontFamily: baseFont)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? Center(child: Text('لا توجد منتجات لهذه الفئة', style: TextStyle(fontFamily: baseFont)))
              : ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: products.length,
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final String quantityKey = product.productId?.toString() ?? 'product_${index}';
                    final quantity = controller.productQuantities[quantityKey] ?? 0;
                    return CartProductCard(
                      item: {
                        'product': product,
                        'quantity': quantity,
                        'price': product.price ?? 0.0,
                        'total_price': (product.price ?? 0.0) * quantity,
                      },
                      isRemoving: false,
                      onAddToCart: () async {
                        final newQuantity = quantity + 1;
                        controller.onQuantityChanged(quantityKey, newQuantity);
                        controller.cart[product] = newQuantity;
                        controller.safeNotifyListeners();
                        await controller.addProductToCart(product, newQuantity);
                      },
                      onIncrease: () async {
                        final newQuantity = quantity + 1;
                        controller.onQuantityChanged(quantityKey, newQuantity);
                        controller.cart[product] = newQuantity;
                        controller.safeNotifyListeners();
                        await controller.addProductToCart(product, newQuantity);
                      },
                      onDecrease: () async {
                        final newQuantity = quantity - 1;
                        if (newQuantity > 0) {
                          controller.onQuantityChanged(quantityKey, newQuantity);
                          controller.cart[product] = newQuantity;
                          controller.safeNotifyListeners();
                          await controller.addProductToCart(product, newQuantity);
                        } else {
                          controller.onQuantityChanged(quantityKey, 0);
                          controller.cart.remove(product);
                          controller.safeNotifyListeners();
                        }
                      },
                    );
                  },
                ),
    );
  }
} 