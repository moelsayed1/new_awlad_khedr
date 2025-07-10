class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic data;

  AppException(this.message, {this.code, this.data});

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  NetworkException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'NetworkException: $message';
}

class AuthException extends AppException {
  AuthException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'AuthException: $message';
}

class ValidationException extends AppException {
  ValidationException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'ValidationException: $message';
}

class ServerException extends AppException {
  ServerException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException extends AppException {
  CacheException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'CacheException: $message';
}

class UnknownException extends AppException {
  UnknownException(String message, {String? code, dynamic data})
      : super(message, code: code, data: data);

  @override
  String toString() => 'UnknownException: $message';
}

// Exception Handler
class ExceptionHandler {
  static AppException handle(dynamic error) {
    if (error is AppException) {
      return error;
    }

    if (error.toString().contains('SocketException') ||
        error.toString().contains('NetworkException')) {
      return NetworkException('لا يوجد اتصال بالإنترنت');
    }

    if (error.toString().contains('401') ||
        error.toString().contains('Unauthorized')) {
      return AuthException('جلسة منتهية الصلاحية');
    }

    if (error.toString().contains('422') ||
        error.toString().contains('Validation')) {
      return ValidationException('بيانات غير صحيحة');
    }

    if (error.toString().contains('500') ||
        error.toString().contains('Server')) {
      return ServerException('خطأ في الخادم');
    }

    return UnknownException('حدث خطأ غير متوقع');
  }

  static String getErrorMessage(AppException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return 'لا يوجد اتصال بالإنترنت';
      case AuthException:
        return 'جلسة منتهية الصلاحية';
      case ValidationException:
        return 'بيانات غير صحيحة';
      case ServerException:
        return 'خطأ في الخادم';
      case CacheException:
        return 'خطأ في التخزين المؤقت';
      case UnknownException:
        return 'حدث خطأ غير متوقع';
      default:
        return exception.message;
    }
  }
} 