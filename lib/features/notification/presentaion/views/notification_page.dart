import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/popup_account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../drawer_slider/controller/notification_provider.dart';
import '../../../drawer_slider/model/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationProvider>().notifications;

    return MainLayout(
      selectedIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Image.asset(
                  AssetsData.drawerIcon,
                  height: 45,
                  width: 45,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),

          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
              child: Text(
                'الاشعارات',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: baseFont),
              ),
            )
          ],
        ),
        drawer: const CustomDrawer(),
        body: ListView.builder(
          padding: EdgeInsets.all(16.0.r),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationCard(notification: notification);
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.h),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 60.h,
                      width: 60.w,
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Image.asset(
                        AssetsData.logoPng,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification.orderDetails,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontFamily: baseFont,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  notification.status,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontFamily: baseFont,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                notification.orderNumber,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification.timeAgo,
                      style: TextStyle(
                        color: Colors.black54,
                        fontFamily: baseFont,
                        fontSize: 14.sp,
                      ),
                    ),
                    CustomButton(
                      text: 'تفاصيل الاوردر',
                      color: darkOrange,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      width: 120.w,
                      height: 28.h,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const OrderDetailsPopup();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
