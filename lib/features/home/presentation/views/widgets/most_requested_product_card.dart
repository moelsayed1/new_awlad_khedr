import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
// Explicitly import the Product from top_rated_model.dart and give it an alias
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as TopRatedProductModel; // <--- FIX IS HERE

class MostRequestedProductCard extends StatelessWidget {
  // Use the aliased Product here
  final TopRatedProductModel.Product product; // <--- FIX IS HERE

  const MostRequestedProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // ... (rest of your widget code) ...
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * .15,
            color: Colors.transparent,
            child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                ? Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AssetsData.logoPng,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    AssetsData.logoPng,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Product Name
                Text(
                  product.productName ?? 'اسم المنتج',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontFamily: baseFont,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 4.h),
                // Product Price (Now correctly accesses 'price' from TopRatedProductModel.Product)
                Text(
                  '${product.price ?? '0'} EGP', 
                  style: TextStyle(  
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: Colors.orange,
                    fontFamily: baseFont,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}