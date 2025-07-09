import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
// Import the specific Product model from top_rated_model.dart with an alias
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as trm; // <--- Make sure this import is correct and aliased
import 'package:awlad_khedr/features/home/presentation/views/widgets/most_requested_product_card.dart';

class MostRequestedProductsSection extends StatelessWidget {
  // The 'products' list must be of type trm.Product
  final List<trm.Product> products; // <--- FIX HERE

  const MostRequestedProductsSection({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  log('Navigate to see all most requested products');
                },
                child: Text(
                  'المزيد',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.orange,
                    fontFamily: baseFont,
                  ),
                ),
              ),
              Text(
                'أكثر طلباً',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: baseFont,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            reverse: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: products.length,
            itemBuilder: (context, index) {
              // Pass the correctly typed product to MostRequestedProductCard
              return MostRequestedProductCard(product: products[index]); // <--- This line should now be fine
            },
          ),
        ),
      ],
    );
  }
}