import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/custom_rating.dart';
import 'package:awlad_khedr/features/order/presentation/views/widgets/popup_order_reciept.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../order/data/model/order_model.dart';
import '../../../order/presentation/controllers/order_provider.dart';

import '../../../../core/assets.dart';

class OrdersViewPage extends StatelessWidget {
  const OrdersViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: InkWell(
            onTap: () {
              GoRouter.of(context).pop();
            },
            child: Row(
              children: [
                Image.asset(
                  AssetsData.back,
                  color: Colors.black,
                  width: 24.w,
                  height: 24.h,
                ),
                Text(
                  'للخلف',
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.black,
                      fontFamily: baseFont,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 100.w,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'الطلبات',
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: baseFont),
            ),
          )
        ],
      ),
      body: const OrdersList(),
    );
  }
}

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderProvider>(context).orders;

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80.sp,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              '... لا توجد طلبات بعد',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
                fontFamily: baseFont,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: orders.length,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15.r)),
              color: Colors.black,
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${order.id} :رقم الطلب',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    '${order.date.year}/${order.date.month}/${order.date.day}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'مطلوب دفعة',
                          style: TextStyle(
                              color: kBrown,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              fontFamily: baseFont),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${order.total} ج.م',
                          style: TextStyle(
                            color: kBrown,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReceiptOrderDetails(order: order);
                              },
                            );
                          },
                          child: Container(
                            width: 116.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.r)),
                                color: Colors.black),
                            child: Center(
                              child: Text(
                                'عرض المنتجات',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: baseFont,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'عربة 1',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontFamily: baseFont),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              AssetsData.cycle,
                              width: 24.w,
                              height: 24.h,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              order.status,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16.sp,
                                  fontFamily: baseFont),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'تقييمك',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontFamily: baseFont),
                            ),
                            const CustomRating(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonReceipt(order: order)),
                  SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
