class ServerException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors; // To hold validation errors (e.g., from 422)

  ServerException(this.message, this.statusCode, {this.errors});

  @override
  String toString() {
    return 'ServerException: $message (Status: $statusCode)';
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() {
    return 'NetworkException: $message';
  }
}