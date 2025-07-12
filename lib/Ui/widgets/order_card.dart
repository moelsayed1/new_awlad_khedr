import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constant.dart';
import '../../Api/models/order_models.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onViewDetails,
    this.onCancel,
  });

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
          // Order Header
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
                    (() {
                      if (order.created_at == null) return '';
                      try {
                        final date = DateTime.tryParse(order.created_at!);
                        if (date == null) return order.created_at!;
                        return '${date.year}/${date.month}/${date.day}';
                      } catch (_) {
                        return order.created_at!;
                      }
                    })(),
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

          // Order Details
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
                            fontFamily: baseFont,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${order.total_amount ?? 0} ج.م',
                          style: TextStyle(
                            color: kBrown,
                            fontWeight: FontWeight.w700,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: onViewDetails,
                          child: Container(
                            width: 116.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.r)),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Text(
                                'عرض التفاصيل',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: baseFont,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'حالة الطلب',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.sp,
                            fontFamily: baseFont,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status ?? ''),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _getStatusText(order.status ?? ''),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: baseFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Action Buttons
                if (onCancel != null && order.status == 'pending')
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: onCancel,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'إلغاء الطلب',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: baseFont,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'مؤكد';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      default:
        return 'غير محدد';
    }
  }
}
