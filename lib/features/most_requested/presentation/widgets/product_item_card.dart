import 'package:flutter/material.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback? onAddToCart;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
    this.onAddToCart,
  });

  bool _isValidImage(String? url) {
    if (url == null || url.isEmpty) return false;
    if (url == 'https://erp.khedrsons.com/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png') return false;
    if (url.toLowerCase().endsWith('فريم.png')) return false;
    return true;
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: baseFont,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'السعــر: ${product.price} ج.م',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.orange[700],
            fontFamily: baseFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'الكمية: $quantity',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black87,
            fontFamily: baseFont,
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 100.w,
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _isValidImage(product.imageUrl)
            ? Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/logoPng.png', fit: BoxFit.contain);
                },
              )
            : Image.asset('assets/images/logoPng.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildQuantityControl() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, color: Colors.orange[700], size: 20),
            onPressed: () => onQuantityChanged(quantity > 0 ? quantity - 1 : 0),
            padding: const EdgeInsets.all(4),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              color: Colors.orange[700],
              fontWeight: FontWeight.bold,
              fontFamily: baseFont,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.orange[700], size: 20),
            onPressed: () => onQuantityChanged(quantity + 1),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onAddToCart,
        child: const Text(
          'إضافة إلى السلة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: baseFont,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Container(
        height: 230.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Details (Left Side)
                    Expanded(child: _buildProductDetails()),
                    const SizedBox(width: 12),
                    // Product Image and Quantity Control (Right Side)
                    Column(
                      children: [
                        _buildProductImage(),
                        SizedBox(height: 28.h),
                        _buildQuantityControl(),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              // Add to Cart Button
              _buildAddToCartButton(),
            ],
          ),
        ),
      ),
    );
  }
}
