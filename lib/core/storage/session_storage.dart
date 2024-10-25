import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';

class SessionStorage {
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(AppConfig.sessionBoxName);
    debugPrint('Session storage initialized: ${hasSession()}');
  }

  Future<void> saveUserSecret(String secret) async {
    await _box.put(AppConfig.userSecretKey, secret);
    debugPrint('User secret saved: $secret');
  }

  Future<void> saveThreadId(String? threadId) async {
    if (threadId != null) {
      await _box.put(AppConfig.threadIdKey, threadId);
      debugPrint('Thread ID saved: $threadId');
    } else {
      await _box.delete(AppConfig.threadIdKey);
      debugPrint('Thread ID cleared');
    }
  }

  Future<String?> getUserSecret() async {
    final secret = _box.get(AppConfig.userSecretKey) as String?;
    debugPrint('Retrieved user secret: $secret');
    return secret;
  }

  Future<String?> getThreadId() async {
    final threadId = _box.get(AppConfig.threadIdKey) as String?;
    debugPrint('Retrieved thread ID: $threadId');
    return threadId;
  }

  Future<void> clearSession() async {
    await _box.clear();
    debugPrint('Session cleared');
  }

  bool hasSession() {
    final hasSecret = _box.containsKey(AppConfig.userSecretKey);
    debugPrint('Has session: $hasSecret');
    return hasSecret;
  }
}
