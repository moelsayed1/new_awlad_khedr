import 'package:awlad_khedr/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppHelpers {
  // Navigation Helpers
  static void navigateTo(BuildContext context, String route,
      {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  static void navigateToReplacement(BuildContext context, String route,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  static void navigateToAndClear(BuildContext context, String route,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  // UI Helpers
  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: baseFont,
          ),
        ),
        backgroundColor: isError ? Colors.red : darkOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showAppDialog(
    BuildContext context,
    String title,
    String message, {
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: baseFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: baseFont),
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  // String Helpers
  static String formatPrice(double price) {
    return NumberFormat.currency(
      locale: 'ar_SA',
      symbol: 'ر.س',
      decimalDigits: 2,
    ).format(price);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'ar').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm', 'ar').format(date);
  }

  static String formatPhone(String phone) {
    if (phone.startsWith('+966')) {
      return phone.replaceFirst('+966', '0');
    }
    return phone;
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Validation Helpers
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[0-9]{10,15}$')
        .hasMatch(phone.replaceAll(RegExp(r'[^\d]'), ''));
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidName(String name) {
    return name.length >= 2;
  }

  // Device Helpers
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) > 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Keyboard Helpers
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // Clipboard Helpers
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static Future<String?> getFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  // File Helpers
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  static String getFileName(String filePath) {
    return filePath.split('/').last;
  }

  static bool isImageFile(String fileName) {
    final extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    return extensions.contains(getFileExtension(fileName));
  }

  static bool isVideoFile(String fileName) {
    final extensions = ['mp4', 'avi', 'mov', 'wmv', 'flv'];
    return extensions.contains(getFileExtension(fileName));
  }

  // Color Helpers
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }

  // List Helpers
  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<T> filterList<T>(List<T> list, bool Function(T) predicate) {
    return list.where(predicate).toList();
  }

  static List<T> sortList<T>(List<T> list, int Function(T, T) compare) {
    final sortedList = List<T>.from(list);
    sortedList.sort(compare);
    return sortedList;
  }

  // Map Helpers
  static Map<K, V> filterMap<K, V>(
      Map<K, V> map, bool Function(K, V) predicate) {
    return Map.fromEntries(
      map.entries.where((entry) => predicate(entry.key, entry.value)),
    );
  }

  static Map<K, V> sortMap<K, V>(Map<K, V> map, int Function(K, K) compare) {
    final sortedKeys = map.keys.toList()..sort(compare);
    return Map.fromEntries(
      sortedKeys.map((key) => MapEntry(key, map[key] as V)),
    );
  }

  // Network Helpers
  static bool isNetworkError(dynamic error) {
    return error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException') ||
        error.toString().contains('TimeoutException');
  }

  static bool isAuthError(dynamic error) {
    return error.toString().contains('401') ||
        error.toString().contains('Unauthorized');
  }

  static bool isServerError(dynamic error) {
    return error.toString().contains('500') ||
        error.toString().contains('Server');
  }

  // Cache Helpers
  static String generateCacheKey(String key, Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return key;
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '$key?${Uri(queryParameters: sortedParams.map((k, v) => MapEntry(k, v.toString()))).query}';
  }

  static bool isCacheExpired(DateTime cacheTime, Duration maxAge) {
    return DateTime.now().difference(cacheTime) > maxAge;
  }
}
