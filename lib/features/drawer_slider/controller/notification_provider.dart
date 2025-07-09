import 'package:flutter/material.dart';

import '../model/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      timeAgo: 'منذ 15 دقيقة',
      orderDetails: 'تم تحضير الاوردر وفي طريقها اليك',
      orderNumber: '#525963',
      status: 'تم التحضير',
    ),
    NotificationModel(
      timeAgo: 'منذ 20 دقيقة',
      orderDetails: 'تم تحضير الاوردر وفي طريقها اليك',
      orderNumber: '#525963',
      status: 'تم التحضير',
    ),
    NotificationModel(
      timeAgo: 'منذ 30 دقيقة',
      orderDetails: 'تم تحضير الاوردر وفي طريقها اليك',
      orderNumber: '#525963',
      status: 'تم التحضير',
    ),
  ];

  List<NotificationModel> get notifications => _notifications;
}
