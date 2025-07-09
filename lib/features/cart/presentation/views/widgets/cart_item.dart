import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/assets.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;

class CartItem extends StatelessWidget {
  final top_rated.Product product;
  final int quantity;
  final int index;
  final void Function(int, int) onQuantityChanged;

  const CartItem({
    super.key,
    required this.product,
    required this.quantity,
    required this.index,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the subtotal for this specific item
    final double itemSubtotal =
        (double.tryParse(product.price ?? '0') ?? 0) * quantity;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side: Product Info (Name, units in cart, price) and Quantity Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontFamily: baseFont,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl, // Right-to-left for Arabic
                ),
                SizedBox(height: 4.h),
                Text(
                  '$quantity وحدة في السلة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                    fontFamily: baseFont,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${itemSubtotal.toStringAsFixed(0)} جنيه ', // Display subtotal
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.orange,
                    fontFamily: baseFont,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 10.h),

                // Quantity Controls (Add/Remove)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (quantity > 1) {
                          onQuantityChanged(index, quantity - 1);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Icon(Icons.remove,
                            size: 20.sp, color: Colors.black),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '$quantity',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: baseFont),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () {
                        onQuantityChanged(index, quantity + 1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child:
                            Icon(Icons.add, size: 20.sp, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),

          // Right Side: Product Image (from model) and Static Labels
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Colors.white,
                  boxShadow: [
                    // Added a subtle shadow to the image container
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                // CONDITIONAL IMAGE DISPLAY
                child: (product.imageUrl != null && product.imageUrl!.isNotEmpty && product.imageUrl! != 'https://erp.khedrsons.com/uploads/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png')
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to logoPng if network image fails to load
                          return Image.asset(AssetsData.logoPng,
                              fit: BoxFit.contain);
                        },
                      )
                    : Image.asset(AssetsData.logoPng,
                        fit: BoxFit.contain), // Fallback if imageUrl is null, empty, or matches problematic URL
              ),
              // SizedBox(height: 5.h),
              // Text(
              //   'as unites',
              //   style: TextStyle(
              //     fontSize: 12.sp,
              //     color: Colors.grey[600],
              //     fontFamily: baseFont,
              //   ),
              //   textDirection: TextDirection.rtl,
              // ),
              // Text(
              //   'الســـــعر',
              //   style: TextStyle(
              //     fontSize: 12.sp,
              //     color: Colors.grey[600],
              //     fontFamily: baseFont,
              //   ),
              //   textDirection: TextDirection.rtl,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
