import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';
import '../../new_core/assets.dart';
import '../../Api/models/product_models.dart' as api_models;

class ProductCard extends StatelessWidget {
  final api_models.Product product;
  final VoidCallback? onTap;
  final Function(int)? onAddToCart;
  
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final price = double.tryParse(product.price?.toString() ?? '0') ?? 0;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 160.w,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.grey[100],
              ),
              child: (product.image != null && product.image!.isNotEmpty)
                  ? Image.network(
                      product.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AssetsData.logoPng,
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  : Image.asset(
                      AssetsData.logoPng,
                      fit: BoxFit.contain,
                    ),
            ),
            SizedBox(height: 8.h),
            
            // Product Name
            Text(
              product.name ?? 'Product Name',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: baseFont,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 4.h),
            
            // Product Price
            Text(
              '${price.toStringAsFixed(0)} جنيه',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontFamily: baseFont,
              ),
              textDirection: TextDirection.rtl,
            ),
            SizedBox(height: 8.h),
            
            // Add to Cart Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onAddToCart?.call(1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                child: Text(
                  'أضف للسلة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontFamily: baseFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 