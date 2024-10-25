import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';

class SessionStorage {
  late Box _box;

  static const String userNameKey = 'user_name';

  Future<void> init() async {
    _box = await Hive.openBox(AppConfig.sessionBoxName);
    debugPrint('Session storage initialized: ${hasSession()}');
  }

  // User name methods
  Future<void> saveUserName(String name) async {
    await _box.put(userNameKey, name);
    debugPrint('User name saved: $name');
  }

  Future<String?> getUserName() async {
    final name = _box.get(userNameKey) as String?;
    debugPrint('Retrieved user name: $name');
    return name;
  }

  // User secret methods
  Future<void> saveUserSecret(String secret) async {
    await _box.put(AppConfig.userSecretKey, secret);
    debugPrint('User secret saved: $secret');
  }

  Future<String?> getUserSecret() async {
    final secret = _box.get(AppConfig.userSecretKey) as String?;
    debugPrint('Retrieved user secret: $secret');
    return secret;
  }

  // Thread ID methods
  Future<void> saveThreadId(String? threadId) async {
    if (threadId != null) {
      await _box.put(AppConfig.threadIdKey, threadId);
      debugPrint('Thread ID saved: $threadId');
    } else {
      await _box.delete(AppConfig.threadIdKey);
      debugPrint('Thread ID cleared');
    }
  }

  Future<String?> getThreadId() async {
    final threadId = _box.get(AppConfig.threadIdKey) as String?;
    debugPrint('Retrieved thread ID: $threadId');
    return threadId;
  }

  // Session management methods
  Future<void> clearSession() async {
    await _box.clear(); // This will clear everything including the user name
    debugPrint('Session cleared');
  }

  bool hasSession() {
    final hasSecret = _box.containsKey(AppConfig.userSecretKey);
    debugPrint('Has session: $hasSecret');
    return hasSecret;
  }

  // Helper method to check if we have a stored name
  bool hasUserName() {
    final hasName = _box.containsKey(userNameKey);
    debugPrint('Has user name: $hasName');
    return hasName;
  }
}
