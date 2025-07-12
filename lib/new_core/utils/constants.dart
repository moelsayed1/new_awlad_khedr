// API Constants
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  static const int timeoutDuration = 30000; // 30 seconds
  
  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  static const String products = '/products';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  
  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  
  // Status Codes
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int validationError = 422;
  static const int serverError = 500;
}

// App Constants
class AppConstants {
  // App Info
  static const String appName = 'أولاد خضر';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_data';
  static const String settingsKey = 'app_settings';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultRadius = 12.0;
  static const double smallRadius = 8.0;
  static const double largeRadius = 20.0;
  static const double defaultElevation = 2.0;
  static const double smallElevation = 1.0;
  static const double largeElevation = 8.0;
  
  // Image Constants
  static const String defaultImage = 'assets/images/placeholder.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultProduct = 'assets/images/default_product.png';
  
  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache
  static const Duration cacheDuration = Duration(hours: 1);
  static const Duration shortCacheDuration = Duration(minutes: 15);
  static const Duration longCacheDuration = Duration(days: 7);
}

// Error Messages
class ErrorMessages {
  static const String networkError = 'لا يوجد اتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم';
  static const String authError = 'جلسة منتهية الصلاحية';
  static const String validationError = 'بيانات غير صحيحة';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String timeoutError = 'انتهت مهلة الاتصال';
  static const String notFoundError = 'المحتوى غير موجود';
  static const String permissionError = 'ليس لديك صلاحية';
  
  // Field Validation
  static const String requiredField = 'هذا الحقل مطلوب';
  static const String invalidEmail = 'البريد الإلكتروني غير صحيح';
  static const String invalidPhone = 'رقم الهاتف غير صحيح';
  static const String invalidPassword = 'كلمة المرور غير صحيحة';
  static const String passwordMismatch = 'كلمة المرور غير متطابقة';
  static const String minLength = 'يجب أن يكون الحقل على الأقل {0} أحرف';
  static const String maxLength = 'يجب أن يكون الحقل على الأكثر {0} أحرف';
}

// Success Messages
class SuccessMessages {
  static const String loginSuccess = 'تم تسجيل الدخول بنجاح';
  static const String registerSuccess = 'تم إنشاء الحساب بنجاح';
  static const String logoutSuccess = 'تم تسجيل الخروج بنجاح';
  static const String profileUpdated = 'تم تحديث الملف الشخصي بنجاح';
  static const String passwordChanged = 'تم تغيير كلمة المرور بنجاح';
  static const String orderPlaced = 'تم تقديم الطلب بنجاح';
  static const String itemAdded = 'تم إضافة العنصر بنجاح';
  static const String itemRemoved = 'تم إزالة العنصر بنجاح';
  static const String itemUpdated = 'تم تحديث العنصر بنجاح';
}

// Localization
class LocalizationConstants {
  static const String ar = 'ar';
  static const String en = 'en';
  static const String defaultLanguage = ar;
  
  static const Map<String, String> supportedLanguages = {
    ar: 'العربية',
    en: 'English',
  };
}

// Theme Constants
class ThemeConstants {
  static const String light = 'light';
  static const String dark = 'dark';
  static const String system = 'system';
  static const String defaultTheme = system;
  
  static const Map<String, String> themes = {
    light: 'فاتح',
    dark: 'داكن',
    system: 'تلقائي',
  };
} 