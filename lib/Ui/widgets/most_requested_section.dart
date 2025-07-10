import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Api/models/product_models.dart' as api_models;
import 'product_card.dart';

class MostRequestedSection extends StatelessWidget {
  final List<api_models.Product> products;
  final Function(api_models.Product)? onProductTap;
  final Function(api_models.Product, int)? onAddToCart;
  
  const MostRequestedSection({
    super.key,
    required this.products,
    this.onProductTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250.h,
      child: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: products.length,
              separatorBuilder: (context, index) => SizedBox(width: 15.w),
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onTap: () => onProductTap?.call(product),
                  onAddToCart: (quantity) => onAddToCart?.call(product, quantity),
                );
              },
            ),
    );
  }
} 