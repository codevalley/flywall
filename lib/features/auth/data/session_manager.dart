import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/errors/exceptions.dart';
import '../domain/user.dart';

class SessionManager {
  final Dio _dio;
  final SessionStorage _storage;
  User? _currentUser;

  SessionManager(this._dio, this._storage);

  User? get currentUser => _currentUser;

  Future<bool> login(String userSecret) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/auth/token',
        data: {'user_secret': userSecret},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storage.saveUserSecret(userSecret);
        _currentUser = User.fromJson(data);
        return true;
      }
      return false;
    } on DioException catch (e) {
      throw AuthException(e.message ?? 'Login failed');
    }
  }

  Future<User> register(String screenName) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/auth/register',
        data: {'screen_name': screenName},
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await login(response.data['user_secret']);
        return user;
      }
      throw const AuthException('Registration failed');
    } on DioException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    _currentUser = null;
  }

  Future<bool> restoreSession() async {
    final userSecret = await _storage.getUserSecret();
    if (userSecret != null) {
      return login(userSecret);
    }
    return false;
  }
}
