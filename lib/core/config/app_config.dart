class AppConfig {
  static const String baseUrl =
      'http://10.0.2.2:8000'; // Update with your API URL
  static const String apiVersion = 'v1';
  static const String apiPath = '/api/$apiVersion';
  static const String wsUrl =
      'ws://10.0.2.2:8000/ws'; // Update with your WebSocket URL

  // Storage keys
  static const String sessionBoxName = 'session_box';
  static const String userSecretKey = 'user_secret';
  static const String threadIdKey = 'thread_id';
}
