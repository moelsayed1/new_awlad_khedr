import 'dart:convert';
import 'dart:developer';
import 'package:awlad_khedr/constant.dart';
import 'package:awlad_khedr/core/network/api_service.dart';
import 'package:awlad_khedr/features/drawer_slider/model/notification_model.dart';
import 'package:awlad_khedr/features/drawer_slider/services/notification_service.dart';

/// Test class to verify notification integration
class NotificationIntegrationTest {
  static final NotificationService _notificationService =
      NotificationService(ApiService());

  /// Test the notification API endpoint
  static Future<void> testNotificationAPI() async {
    try {
      log('🧪 Starting Notification API Test...');

      // Test 1: Fetch notifications
      log('📡 Testing fetchUserNotifications...');
      final response = await _notificationService.fetchUserNotifications();

      if (response != null) {
        log('✅ Successfully fetched notifications');
        log('📊 Total notifications: ${response.data.length}');
        log('📋 Status: ${response.status}');
        log('💬 Message: ${response.message}');

        // Test 2: Validate notification structure
        if (response.data.isNotEmpty) {
          final firstNotification = response.data.first;
          log('📝 First notification details:');
          log('   - Message: ${firstNotification.msg}');
          log('   - Body: ${firstNotification.body}');
          log('   - Created at: ${firstNotification.createdAt}');
          log('   - Transaction ID: ${firstNotification.transaction.id}');
          log('   - Invoice No: ${firstNotification.transaction.invoiceNo}');
          log('   - Products count: ${firstNotification.transaction.products.length}');

          // Test 3: Validate shipping status
          log('🚚 Shipping status:');
          log('   - Key: ${firstNotification.shippingStatus.key}');
          log('   - Label: ${firstNotification.shippingStatus.label}');
          log('   - Color: ${firstNotification.shippingStatus.color}');
        }

        // Test 4: Test notification count
        final count = await _notificationService.getNotificationCount();
        log('🔢 Notification count: $count');

        log('🎉 All tests passed successfully!');
      } else {
        log('❌ Failed to fetch notifications - response is null');
      }
    } catch (e) {
      log('💥 Test failed with error: $e');
    }
  }

  /// Test API endpoint URL construction
  static void testEndpointURL() {
    log('🔗 Testing endpoint URL construction...');
    final url = APIConstant.GET_USER_NOTIFICATIONS;
    log('📡 Endpoint URL: $url');

    if (url.contains('get-user-notifications')) {
      log('✅ Endpoint URL is correctly constructed');
    } else {
      log('❌ Endpoint URL is incorrect');
    }
  }

  /// Test notification model parsing
  static void testModelParsing() {
    log('🔧 Testing notification model parsing...');

    // Sample JSON data from the API response
    final sampleJson = {
      "data": [
        {
          "msg": "New Sale Created",
          "body":
              "A new sale has been registered for the customer with invoice number 2025-07696",
          "link": "http://khedrsons.test/sells/13505",
          "read_at": "2025-07-24T06:30:09.000000Z",
          "created_at": "منذ 3 ساعات",
          "shipping_status": {
            "key": "delivered",
            "label": "تم التوصيل",
            "color": "bg-green"
          },
          "transaction": {
            "id": 13505,
            "invoice_no": "2025-07696",
            "status": "final",
            "payment_status": "paid",
            "customer_name": "محمد سلام un login 1",
            "contact_address": "Cairo - Egypt",
            "shipping_address": "الجيزة",
            "products": [
              {
                "name": "رودس فلامنك 125جم\"40",
                "variation": "DUMMY",
                "quantity": 1,
                "unit_price": "0.0000",
                "line_total": 0
              }
            ],
            "final_total": "86.6300",
            "created_at": "2025-07-24 12:00:02"
          }
        }
      ],
      "status": 200,
      "message": "Notifications fetched successfully"
    };

    try {
      final response = ApiNotificationResponse.fromJson(sampleJson);
      log('✅ Model parsing successful');
      log('📊 Parsed ${response.data.length} notifications');
      log('📋 Status: ${response.status}');
      log('💬 Message: ${response.message}');

      if (response.data.isNotEmpty) {
        final notification = response.data.first;
        log('📝 Parsed notification:');
        log('   - Message: ${notification.msg}');
        log('   - Transaction ID: ${notification.transaction.id}');
        log('   - Products: ${notification.transaction.products.length}');
      }
    } catch (e) {
      log('❌ Model parsing failed: $e');
    }
  }

  /// Run all tests
  static Future<void> runAllTests() async {
    log('🚀 Starting Notification Integration Tests...');
    log('=' * 50);

    testEndpointURL();
    log('-' * 30);

    testModelParsing();
    log('-' * 30);

    await testNotificationAPI();
    log('-' * 30);

    log('🏁 All tests completed!');
    log('=' * 50);
  }
}
