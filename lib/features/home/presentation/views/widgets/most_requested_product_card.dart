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
            child: product.imageUrl != null
                ? Image.network(
                    product.imageUrl ?? 'https://img4cdn.haraj.com.sa/userfiles30/2022-08-23/800x689-1_-GO__MTY2MTI4MDM2MzM5OTk0NDE1OTEwNQ.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/logoPng.png', fit: BoxFit.cover);
                    },
                  )
                : Image.asset(
                    AssetsData.callCenter,
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