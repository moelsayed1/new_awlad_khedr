import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;
import 'package:awlad_khedr/core/theme/app_colors.dart';

class CartSheet extends StatelessWidget {
  final Map<top_rated.Product, int> cart;
  final double total;
  final VoidCallback onClose;
  final VoidCallback? onPaymentSuccess;

  const CartSheet({
    super.key,
    required this.cart,
    required this.total,
    required this.onClose,
    this.onPaymentSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondary,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'السلة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (cart.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text(
                            'السلة فارغة',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                              fontFamily: baseFont,
                            ),
                          ),
                        ),
                      ...cart.entries.map((entry) {
                        final product = entry.key;
                        final quantity = entry.value;
                        final price = product.price;
                        double priceValue = 0;
                        if (price is num) {
                          priceValue = (price as num?)?.toDouble() ?? 0;
                        } else if (price is String) {
                          priceValue = double.tryParse(price) ?? 0;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  product.productName ?? 'Unknown Product',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Tajawal',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'الكمية: $quantity',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: baseFont,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.white54),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${total.toStringAsFixed(2)} ج.م',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                    Text(
                      ':الإجمالـي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cart.isNotEmpty
                      ? () {
                          onClose();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CartViewPage(
                                products: cart.keys.toList(),
                                quantities: cart.values.toList(),
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'الذهاب الي السلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: baseFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}