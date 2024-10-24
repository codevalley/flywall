abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class StorageException extends AppException {
  const StorageException(super.message);
}
