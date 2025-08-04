import 'package:awlad_khedr/features/cart/presentation/views/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart' as top_rated;
import 'package:awlad_khedr/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/home/presentation/controllers/category_controller.dart';
import 'package:awlad_khedr/features/cart/services/cart_api_service.dart';
import 'dart:developer';

class CartSheet extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback? onPaymentSuccess;
  final List<Map<String, dynamic>>? cartItems;
  final double? total;

  const CartSheet({
    super.key,
    required this.onClose,
    this.onPaymentSuccess,
    this.cartItems,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
            return Consumer<CategoryController>(
          builder: (context, controller, child) {
            // Use provided cart items or fall back to fetched cart items
            final items = cartItems ?? controller.fetchedCartItems;
            final cartTotal = total ?? controller.fetchedCartTotal;
        
        // CRITICAL FIX: Add validation logging
        log('🔍 CartSheet: ${items?.length ?? 0} items, Total: $cartTotal');
        if (items != null) {
          for (var item in items) {
            final product = item['product'] as top_rated.Product;
            log('   - ${product.productName}: ${item['quantity']} units');
          }
        }
        
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'السلة',
                    style: TextStyle(
                      color: Colors.black,
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
                          if (items?.isEmpty ?? true)
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
                          ...(items?.map((item) {
                            final product = item['product'] as top_rated.Product;
                            final quantity = item['quantity'] as int;
                            final price = item['price'] as double;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // الكمية في أقصى اليمين
                                  Text(
                                    'الكمية: $quantity',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                      fontFamily: baseFont,
                                    ),
                                  ),
                                  // اسم المنتج في أقصى الشمال
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        product.productName ?? 'منتج غير معروف',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontFamily: baseFont,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textDirection: TextDirection.rtl,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList() ?? []),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black45),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(cartTotal ?? 0.0).toStringAsFixed(2)} ج.م',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          ':الإجمالـي',
                          style: TextStyle(
                            color: Colors.black,
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
                      onPressed: (items?.isNotEmpty ?? false)
                          ? () async {
                              // CRITICAL FIX: Navigate directly since products are already added
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CartViewPage(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFC6E2A),
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
      },
    );
  }
}