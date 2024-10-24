import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_config.dart';

class SessionStorage {
  late Box _box;

  Future<void> init() async {
    _box = await Hive.openBox(AppConfig.sessionBoxName);
  }

  Future<void> saveUserSecret(String secret) async {
    await _box.put(AppConfig.userSecretKey, secret);
  }

  Future<void> saveThreadId(String? threadId) async {
    if (threadId != null) {
      await _box.put(AppConfig.threadIdKey, threadId);
    } else {
      await _box.delete(AppConfig.threadIdKey);
    }
  }

  Future<String?> getUserSecret() async {
    return _box.get(AppConfig.userSecretKey);
  }

  Future<String?> getThreadId() async {
    return _box.get(AppConfig.threadIdKey);
  }

  Future<void> clearSession() async {
    await _box.clear();
  }

  bool hasSession() {
    return _box.containsKey(AppConfig.userSecretKey);
  }
}
