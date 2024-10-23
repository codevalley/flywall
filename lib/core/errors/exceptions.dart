abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class ServerException extends AppException {
  const ServerException([super.message = 'Server error occurred']);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error occurred']);
}

class CacheException extends AppException {
  const CacheException([super.message = 'Cache error occurred']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error occurred']);
}
