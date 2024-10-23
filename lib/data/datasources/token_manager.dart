import 'package:hive_flutter/hive_flutter.dart';

class TokenManager {
  static const String _tokenBoxName = 'auth_box';
  static const String _tokenKey = 'auth_token';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_tokenBoxName);
  }

  Future<void> saveToken(String token) async {
    final box = Hive.box<String>(_tokenBoxName);
    await box.put(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final box = Hive.box<String>(_tokenBoxName);
    return box.get(_tokenKey);
  }

  Future<void> deleteToken() async {
    final box = Hive.box<String>(_tokenBoxName);
    await box.delete(_tokenKey);
  }
}
