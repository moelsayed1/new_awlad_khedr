import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';
import '../../new_core/assets.dart';
import '../../Api/models/cart_models.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final Function(int)? onQuantityChanged;
  final VoidCallback? onDelete;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    this.onQuantityChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final price = cartItem.price ?? 0;
    final quantity = cartItem.quantity ?? 0;
    final itemSubtotal = price * quantity;

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
          // Left Side: Product Info and Quantity Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product_name ?? 'Product Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontFamily: baseFont,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
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
                  '${itemSubtotal.toStringAsFixed(0)} جنيه',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.orange,
                    fontFamily: baseFont,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                SizedBox(height: 10.h),

                // Quantity Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (quantity > 1) {
                          onQuantityChanged?.call(quantity - 1);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: () {
                        onQuantityChanged?.call(quantity + 1);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),

          // Right Side: Product Image and Delete Button
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
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: (cartItem.product_image != null &&
                        cartItem.product_image!.isNotEmpty)
                    ? Image.network(
                        cartItem.product_image!,
                        fit: BoxFit.contain,
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

              // Delete Button
              if (onDelete != null)
                InkWell(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 16.sp,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
