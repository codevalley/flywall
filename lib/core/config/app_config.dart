// lib/core/config/app_config.dart
class AppConfig {
  static const bool useLocalHost = false; // Set to false for production

  // API Configuration
  static String get baseUrl => useLocalHost
      ? 'http://10.0.2.2:8000' // Android emulator localhost
      : 'https://fapi.nyn.sh'; // Replace with your production API

  static const String apiVersion = 'v1';
  static String get apiPath => '/api/$apiVersion';

  // WebSocket Configuration
  static String get wsUrl =>
      useLocalHost ? 'ws://10.0.2.2:8000/ws' : 'wss://fapi.nyn.sh/ws';

  // Storage keys
  static const String sessionBoxName = 'flywall_session';
  static const String userSecretKey = 'user_secret';
  static const String threadIdKey = 'thread_id';

  // API Endpoints
  static String get authEndpoint => '$baseUrl/auth';
  static String get sidekickEndpoint => '$baseUrl$apiPath/sidekick';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Error Messages
  static const String networkErrorMessage =
      'Unable to connect to the server. Please check your internet connection.';
  static const String serverErrorMessage =
      'Something went wrong on our end. Please try again later.';
  static const String authErrorMessage =
      'Authentication failed. Please try again.';
}
