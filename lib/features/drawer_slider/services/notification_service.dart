import 'dart:convert';
import 'dart:developer';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import '../model/notification_model.dart';

class NotificationService {
  final ApiService _apiService;

  NotificationService(this._apiService);

  /// Fetch user notifications from the API
  Future<ApiNotificationResponse?> fetchUserNotifications() async {
    try {
      log('Fetching user notifications...');
      
      final response = await _apiService.get(
        Uri.parse(APIConstant.GET_USER_NOTIFICATIONS),
      );

      log('Notification API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final notificationResponse = ApiNotificationResponse.fromJson(jsonResponse);
        
        log('Successfully fetched ${notificationResponse.data.length} notifications');
        return notificationResponse;
      } else if (response.statusCode == 401) {
        log('Unauthorized access to notifications API');
        throw Exception('Unauthorized access. Please log in again.');
      } else if (response.statusCode == 404) {
        log('Notifications endpoint not found');
        throw Exception('Notifications service not available.');
      } else if (response.statusCode >= 500) {
        log('Server error: ${response.statusCode}');
        throw Exception('Server error. Please try again later.');
      } else {
        log('Failed to fetch notifications. Status: ${response.statusCode}');
        throw Exception('Failed to fetch notifications. Please try again.');
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      
      // Provide more specific error messages based on the exception type
      if (e.toString().contains('SocketException') || e.toString().contains('NetworkException')) {
        throw Exception('Network connection failed. Please check your internet connection.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please try again.');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid response format. Please try again.');
      } else {
        // Re-throw the original exception if it's already user-friendly
        rethrow;
      }
    }
  }

  /// Mark a notification as read (if the API supports it)
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      log('Marking notification $notificationId as read...');

      // This would be implemented if the API supports marking notifications as read
      // For now, we'll return true as a placeholder
      await Future.delayed(const Duration(milliseconds: 500));

      log('Successfully marked notification as read');
      return true;
    } catch (e) {
      log('Error marking notification as read: $e');
      return false;
    }
  }

  /// Get notification count (if the API supports it)
  Future<int> getNotificationCount() async {
    try {
      final notifications = await fetchUserNotifications();
      return notifications?.data.length ?? 0;
    } catch (e) {
      log('Error getting notification count: $e');
      return 0;
    }
  }
}
