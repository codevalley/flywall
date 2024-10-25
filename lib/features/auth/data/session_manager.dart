// lib/features/auth/data/session_manager.dart
import '../../../core/network/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/errors/exceptions.dart';
import '../domain/user.dart';

class SessionManager {
  final ApiClient _apiClient;
  final SessionStorage _storage;
  User? _currentUser;

  SessionManager(this._apiClient, this._storage);

  User? get currentUser => _currentUser;

  Future<bool> login(String userSecret) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/token',
        data: {'user_secret': userSecret},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _storage.saveUserSecret(userSecret);
        _currentUser = User.fromJson(data);
        // Set the auth token in the API client
        _apiClient.setAuthToken(_currentUser!.accessToken!);
        return true;
      }
      return false;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<User> register(String screenName) async {
    try {
      final response = await _apiClient.post(
        '${AppConfig.authEndpoint}/register',
        data: {'screen_name': screenName},
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await login(response.data['user_secret']);
        return user;
      }
      throw const AuthException('Registration failed');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    _currentUser = null;
    _apiClient.clearAuthToken();
  }

  Future<bool> restoreSession() async {
    final userSecret = await _storage.getUserSecret();
    if (userSecret != null) {
      return login(userSecret);
    }
    return false;
  }
}
