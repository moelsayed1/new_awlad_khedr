import 'package:flutter/material.dart';
import 'dart:developer';
import '../model/notification_model.dart';
import '../services/notification_service.dart';
import 'package:awlad_khedr/core/network/api_service.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationService _notificationService;

  // Legacy static notifications (for backward compatibility)
  final List<NotificationModel> _legacyNotifications = [
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

  // New API-based notifications
  List<ApiNotification> _apiNotifications = [];
  bool _isLoading = false;
  String? _error;
  bool _useApiNotifications =
      true; // Flag to switch between legacy and API notifications

  // Message display flags to prevent duplicate SnackBars
  bool _hasShownSuccessMessage = false;
  bool _hasShownErrorMessage = false;
  bool _hasShownInfoMessage = false;

  // Read/unread tracking
  Set<String> _readNotificationIds = {};

  NotificationProvider()
      : _notificationService = NotificationService(ApiService());

  // Getters
  List<NotificationModel> get legacyNotifications => _legacyNotifications;
  List<ApiNotification> get apiNotifications => _apiNotifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get useApiNotifications => _useApiNotifications;

  // Message display flags
  bool get hasShownSuccessMessage => _hasShownSuccessMessage;
  bool get hasShownErrorMessage => _hasShownErrorMessage;
  bool get hasShownInfoMessage => _hasShownInfoMessage;

  /// Get unread notifications count for badge
  int get unreadCount {
    if (_useApiNotifications) {
      return _apiNotifications
          .where((notification) =>
              !_readNotificationIds.contains(notification.link))
          .length;
    }
    return 0; // Legacy notifications don't have read status
  }

  /// Get unread notifications
  List<ApiNotification> get unreadNotifications {
    if (_useApiNotifications) {
      return _apiNotifications
          .where((notification) =>
              !_readNotificationIds.contains(notification.link))
          .toList();
    }
    return [];
  }

  /// Mark a notification as read
  void markNotificationAsRead(String notificationId) {
    _readNotificationIds.add(notificationId);
    notifyListeners();
    log('Notification marked as read: $notificationId. Unread count: $unreadCount');
  }

  /// Mark all notifications as read
  void markAllNotificationsAsRead() {
    for (final notification in _apiNotifications) {
      _readNotificationIds.add(notification.link);
    }
    notifyListeners();
    log('All notifications marked as read. Unread count: $unreadCount');
  }

  /// Check if a notification is read
  bool isNotificationRead(String notificationId) {
    return _readNotificationIds.contains(notificationId);
  }

  /// Mark a notification as read (API call)
  Future<void> markNotificationAsReadAPI(String notificationId) async {
    try {
      final success =
          await _notificationService.markNotificationAsRead(notificationId);
      if (success) {
        log('NotificationProvider: Successfully marked notification as read via API');
      }
    } catch (e) {
      log('NotificationProvider: Error marking notification as read via API: $e');
    }
  }

  /// Get notification count
  Future<int> getNotificationCount() async {
    try {
      return await _notificationService.getNotificationCount();
    } catch (e) {
      log('NotificationProvider: Error getting notification count: $e');
      return 0;
    }
  }

  /// Toggle between API and legacy notifications (for testing)
  void toggleNotificationSource() {
    _useApiNotifications = !_useApiNotifications;
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear all message states
  void clearMessages() {
    _error = null;
    notifyListeners();
  }

  /// Reset message display flags (call this when screen is first opened)
  void resetMessageFlags() {
    _hasShownSuccessMessage = false;
    _hasShownErrorMessage = false;
    _hasShownInfoMessage = false;
    notifyListeners();
  }

  // For backward compatibility - returns either API notifications or legacy ones
  List<NotificationModel> get notifications {
    if (_useApiNotifications && _apiNotifications.isNotEmpty) {
      // Convert API notifications to legacy format for backward compatibility
      return _apiNotifications
          .map((apiNotif) => NotificationModel(
                timeAgo: apiNotif.createdAt,
                orderDetails: apiNotif.body,
                orderNumber: '#${apiNotif.transaction.invoiceNo}',
                status: apiNotif.shippingStatus.label,
              ))
          .toList();
    }
    return _legacyNotifications;
  }

  /// Fetch notifications from the API
  Future<void> fetchNotifications() async {
    if (!_useApiNotifications) return;

    _isLoading = true;
    _error = null;
    // Reset message flags when starting a new fetch
    _hasShownSuccessMessage = false;
    _hasShownErrorMessage = false;
    _hasShownInfoMessage = false;
    notifyListeners();

    try {
      log('NotificationProvider: Fetching notifications from API...');

      final response = await _notificationService.fetchUserNotifications();

      if (response != null) {
        _apiNotifications = response.data;
        log('NotificationProvider: Successfully fetched ${_apiNotifications.length} notifications');
        // Don't set success message here - let UI handle it
      } else {
        _apiNotifications = [];
        log('NotificationProvider: No notifications received from API');
        // Don't set info message here - let UI handle it
      }

      _error = null;
    } catch (e) {
      log('NotificationProvider: Error fetching notifications: $e');
      _error = _getUserFriendlyErrorMessage(e.toString());
      _apiNotifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Convert technical error messages to user-friendly messages
  String _getUserFriendlyErrorMessage(String error) {
    if (error.contains('Unauthorized') || error.contains('401')) {
      return 'انتهت صلاحية الجلسة. يرجى إعادة تسجيل الدخول';
    } else if (error.contains('Network') || error.contains('Connection')) {
      return 'فشل في الاتصال بالخادم. تحقق من اتصال الإنترنت';
    } else if (error.contains('Timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى';
    } else if (error.contains('404')) {
      return 'خدمة الإشعارات غير متاحة حالياً';
    } else if (error.contains('500') || error.contains('Server')) {
      return 'خطأ في الخادم. يرجى المحاولة لاحقاً';
    } else {
      return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
    }
  }

  /// Mark success message as shown
  void markSuccessMessageShown() {
    _hasShownSuccessMessage = true;
    notifyListeners();
  }

  /// Mark error message as shown
  void markErrorMessageShown() {
    _hasShownErrorMessage = true;
    notifyListeners();
  }

  /// Mark info message as shown
  void markInfoMessageShown() {
    _hasShownInfoMessage = true;
    notifyListeners();
  }

  /// Get success message for UI display
  String? get successMessage {
    if (_apiNotifications.isNotEmpty &&
        _error == null &&
        !_hasShownSuccessMessage) {
      return 'تم تحميل ${_apiNotifications.length} إشعار بنجاح';
    }
    return null;
  }

  /// Get error message for UI display
  String? get errorMessage {
    if (_error != null && !_hasShownErrorMessage) {
      return _error;
    }
    return null;
  }

  /// Get info message for UI display
  String? get infoMessage {
    if (_apiNotifications.isEmpty &&
        _error == null &&
        !_isLoading &&
        !_hasShownInfoMessage) {
      return 'لا توجد إشعارات جديدة';
    }
    return null;
  }

  /// Refresh notifications (pull to refresh)
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Check if there are any notifications
  bool get hasNotifications {
    if (_useApiNotifications) {
      return _apiNotifications.isNotEmpty;
    }
    return _legacyNotifications.isNotEmpty;
  }
}
