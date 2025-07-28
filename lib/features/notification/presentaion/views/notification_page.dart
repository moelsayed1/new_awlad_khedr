import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/assets.dart';
import 'package:awlad_khedr/core/custom_button.dart';
import 'package:awlad_khedr/core/main_layout.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/side_slider.dart';
import 'package:awlad_khedr/features/drawer_slider/presentation/views/widgets/popup_account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import '../../../drawer_slider/controller/notification_provider.dart';
import '../../../drawer_slider/model/notification_model.dart';
import 'package:awlad_khedr/features/invoice/data/invoice_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Reset message flags and fetch notifications when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notificationProvider = context.read<NotificationProvider>();
      notificationProvider.resetMessageFlags();
      notificationProvider.fetchNotifications();
      // Mark all notifications as read when the screen is opened
      notificationProvider.markAllNotificationsAsRead();
    });
  }

  void _showSnackBar(String message,
      {Color? backgroundColor, Color? textColor, IconData? icon}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor ?? darkOrange,
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: textColor ?? Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: baseFont,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          margin: EdgeInsets.all(16.r),
          elevation: 8,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
    );
  }

  void _showErrorSnackBar(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: Icons.error_outline,
    );
  }

  void _showInfoSnackBar(String message) {
    _showSnackBar(
      message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      icon: Icons.info_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                final unreadCount = notificationProvider.unreadCount;
                return Row(
                  children: [
                    if (unreadCount > 0)
                      TextButton(
                        onPressed: () {
                          notificationProvider.markAllNotificationsAsRead();
                          _showSuccessSnackBar(
                              'تم تحديد جميع الإشعارات كمقروءة');
                        },
                        child: Text(
                          'تحديد الكل كمقروء',
                          style: TextStyle(
                            color: darkOrange,
                            fontSize: 14.sp,
                            fontFamily: baseFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        drawer: const CustomDrawer(),
        body: Consumer<NotificationProvider>(
          builder: (context, notificationProvider, child) {
            // Show success message when notifications are loaded (only once)
            if (notificationProvider.successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final message = notificationProvider.successMessage;
                if (message != null) {
                  _showSuccessSnackBar(message);
                  // Mark the message as shown to prevent duplicates
                  notificationProvider.markSuccessMessageShown();
                }
              });
            }

            // Show error message when there's an error (only once)
            if (notificationProvider.errorMessage != null &&
                !notificationProvider.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final message = notificationProvider.errorMessage;
                if (message != null) {
                  _showErrorSnackBar(message);
                  // Mark the message as shown to prevent duplicates
                  notificationProvider.markErrorMessageShown();
                }
              });
            }

            // Show info message when no notifications are available (only once)
            if (notificationProvider.infoMessage != null &&
                !notificationProvider.isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final message = notificationProvider.infoMessage;
                if (message != null) {
                  _showInfoSnackBar(message);
                  // Mark the message as shown to prevent duplicates
                  notificationProvider.markInfoMessageShown();
                }
              });
            }

            if (notificationProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(darkOrange),
                ),
              );
            }

            if (notificationProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.sp,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'حدث خطأ في تحميل الإشعارات',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: baseFont,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      notificationProvider.error ?? 'حدث خطأ غير متوقع',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: baseFont,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'إعادة المحاولة',
                      color: darkOrange,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      width: 120.w,
                      height: 40.h,
                      onTap: () {
                        notificationProvider.clearError();
                        notificationProvider.fetchNotifications();
                      },
                    ),
                  ],
                ),
              );
            }

            if (!notificationProvider.hasNotifications) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'لا توجد إشعارات جديدة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: baseFont,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await notificationProvider.refreshNotifications();
                // Show appropriate message based on the result (only for refresh)
                if (notificationProvider.apiNotifications.isNotEmpty) {
                  _showSuccessSnackBar('تم تحديث الإشعارات بنجاح');
                } else if (notificationProvider.error == null) {
                  _showInfoSnackBar('لا توجد إشعارات جديدة');
                }
              },
              backgroundColor: Colors.white,
              color: darkOrange,
              child: ListView.builder(
                padding: EdgeInsets.all(16.0.r),
                itemCount: notificationProvider.useApiNotifications
                    ? notificationProvider.apiNotifications.length
                    : notificationProvider.legacyNotifications.length,
                itemBuilder: (context, index) {
                  if (notificationProvider.useApiNotifications) {
                    final apiNotification =
                        notificationProvider.apiNotifications[index];
                    return ApiNotificationCard(notification: apiNotification);
                  } else {
                    final legacyNotification =
                        notificationProvider.legacyNotifications[index];
                    return LegacyNotificationCard(
                        notification: legacyNotification);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ApiNotificationCard extends StatelessWidget {
  final ApiNotification notification;

  const ApiNotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final isRead =
            notificationProvider.isNotificationRead(notification.link);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.h),
            child: Card(
              color: Colors.white,
              elevation: isRead ? 2 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(
                  color: isRead
                      ? Colors.grey.withOpacity(0.2)
                      : darkOrange.withOpacity(0.5),
                  width: isRead ? 1 : 2,
                ),
              ),
              child: InkWell(
                onTap: () {
                  // Mark notification as read when tapped
                  if (!isRead) {
                    notificationProvider
                        .markNotificationAsRead(notification.link);
                  }

                  // Show order details
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        ChangeNotifierProvider<InvoiceProvider>(
                      create: (_) => InvoiceProvider(),
                      builder: (providerContext, child) =>
                          Consumer<InvoiceProvider>(
                        builder: (context, invoiceProvider, _) {
                          return OrderDetailsPopup(
                              transactionId: notification.transaction.id);
                        },
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16.r),
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
                              color: isRead
                                  ? Colors.grey.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.msg,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontFamily: baseFont,
                                          color: isRead
                                              ? Colors.black54
                                              : Colors.black,
                                          fontWeight: isRead
                                              ? FontWeight.w500
                                              : FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    if (!isRead)
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  notification.body,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: baseFont,
                                    color: isRead
                                        ? Colors.black45
                                        : Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(notification
                                                .shippingStatus.color)
                                            .withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Text(
                                        notification.shippingStatus.label,
                                        style: TextStyle(
                                          color: _getStatusColor(notification
                                              .shippingStatus.color),
                                          fontFamily: baseFont,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '#${notification.transaction.invoiceNo}',
                                      style: TextStyle(
                                        color: isRead
                                            ? Colors.black45
                                            : Colors.black54,
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
                            notification.createdAt,
                            style: TextStyle(
                              color: isRead ? Colors.black38 : Colors.black54,
                              fontFamily: baseFont,
                              fontSize: 14.sp,
                            ),
                          ),
                          CustomButton(
                            text: 'تفاصيل الاوردر',
                            color: isRead ? Colors.grey : darkOrange,
                            textColor: Colors.white,
                            fontSize: 14.sp,
                            width: 120.w,
                            height: 28.h,
                            onTap: () {
                              // Mark notification as read when details are viewed
                              if (!isRead) {
                                notificationProvider
                                    .markNotificationAsRead(notification.link);
                              }

                              // Create complete transaction data from notification including products
                              final transactionData = {
                                'final_total':
                                    notification.transaction.finalTotal,
                                'invoice_no':
                                    notification.transaction.invoiceNo,
                                'invoice_number':
                                    notification.transaction.invoiceNo,
                                'sell_lines': notification.transaction.products
                                    .map((product) => {
                                          'product': {
                                            'name': product.name,
                                            'id': product
                                                .hashCode, // Use hashcode as unique ID
                                          },
                                          'quantity':
                                              product.quantity.toString(),
                                          'unit_price': product.unitPrice,
                                          'line_total':
                                              product.lineTotal.toString(),
                                        })
                                    .toList(),
                              };

                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    OrderDetailsPopup(
                                  transaction: transactionData,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      // Remove the products section completely
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String colorClass) {
    switch (colorClass) {
      case 'bg-green':
        return Colors.green;
      case 'bg-info':
        return Colors.blue;
      case 'bg-warning':
        return Colors.orange;
      case 'bg-danger':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}

class LegacyNotificationCard extends StatelessWidget {
  final NotificationModel notification;

  const LegacyNotificationCard({super.key, required this.notification});

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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
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
                        final transactionId = int.tryParse(
                            notification.orderNumber.replaceAll('#', ''));
                        if (transactionId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid order number')),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ChangeNotifierProvider<InvoiceProvider>(
                            create: (_) => InvoiceProvider(),
                            builder: (providerContext, child) =>
                                Consumer<InvoiceProvider>(
                              builder: (context, invoiceProvider, _) {
                                return OrderDetailsPopup(
                                    transactionId: transactionId);
                              },
                            ),
                          ),
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
