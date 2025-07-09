import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/most_requested/data/model/top_rated_model.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/widgets/payment_app_bar.dart';
import 'package:awlad_khedr/features/payment_gateway/presentation/views/widgets/payment_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:awlad_khedr/features/order/data/model/order_model.dart';
import 'package:awlad_khedr/features/order/presentation/controllers/order_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:awlad_khedr/core/app_router.dart';

class PaymentView extends StatelessWidget {
  final List<Product> products;
  final double total;
  final VoidCallback? onPaymentSuccess;

  const PaymentView({super.key, required this.products, required this.total, this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaymentAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'تفاصيل الطلب',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: baseFont,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => Divider(height: 20.h),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: (product.imageUrl != null &&
                                          product.imageUrl!.isNotEmpty &&
                                          product.imageUrl! != 'https://erp.khedrsons.com/uploads/img/1745829725_%D9%81%D8%B1%D9%8A%D9%85.png' &&
                                          !product.imageUrl!.toLowerCase().endsWith('فريم.png'))
                                      ? Image.network(
                                          product.imageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset('assets/images/logoPng.png', fit: BoxFit.contain);
                                          },
                                        )
                                      : Image.asset('assets/images/logoPng.png', fit: BoxFit.contain),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      product.productName ?? '',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: baseFont,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'السعر: ${product.price} ج.م',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14.sp,
                                        fontFamily: baseFont,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(height: 32.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${total.toStringAsFixed(2)} ج.م',
                          style: TextStyle(
                            color: darkOrange,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: baseFont,
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
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              PaymentForm(
                onPaymentSuccess: () {
                  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
                  final order = Order(
                    id: UniqueKey().toString(),
                    date: DateTime.now(),
                    products: products,
                    total: total,
                    status: 'جاري الاستلام',
                  );
                  orderProvider.addOrder(order);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إرسال الطلب بنجاح!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  GoRouter.of(context).go(AppRouter.kOrdersViewPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
