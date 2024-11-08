// lib/features/auth/data/session_manager.dart
import 'package:flutter/foundation.dart';
import '../../../core/network/api_client.dart';
import '../../../core/config/app_config.dart';
import '../../../core/storage/session_storage.dart';
import '../../../core/errors/exceptions.dart';
import '../domain/user.dart';
import 'package:dio/dio.dart';

class SessionManager {
  final ApiClient _apiClient;
  final SessionStorage _storage;
  User? _currentUser;

  SessionManager(this._apiClient, this._storage);

  User? get currentUser => _currentUser;

  Future<bool> login(String userSecret) async {
    try {
      debugPrint('Attempting login with secret: $userSecret');

      // Using form data instead of JSON for the token endpoint
      final response = await _apiClient.post(
        AppConfig.tokenEndpoint,
        data: {'user_secret': userSecret},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      debugPrint('Login response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['screen_name'] != null) {
          await _storage.saveUserName(data['screen_name']);
        }
        // Save the access token and user secret
        await _storage.saveUserSecret(userSecret);

        // Store current user with token
        _currentUser = User(
          id: data['user_id'] ?? '',
          screenName: data['screen_name'] ?? '',
          accessToken: data['access_token'],
        );

        // Set the auth token for future requests
        _apiClient.setAuthToken(_currentUser!.accessToken!);

        // Fetch additional user info
        await _fetchUserInfo();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      throw AuthException(e.toString());
    }
  }

  Future<bool> restoreWithSecret(String secret) async {
    try {
      debugPrint('Restoring session with provided secret');
      // Clear any existing session first
      await logout();
      // Attempt to login with the provided secret
      return login(secret);
    } catch (e) {
      debugPrint('Restore with secret error: $e');
      throw const AuthException('Invalid secret or session expired');
    }
  }

  Future<User> register(String screenName) async {
    try {
      debugPrint('Attempting registration for: $screenName');

      final response = await _apiClient.post(
        AppConfig.registerEndpoint,
        data: {'screen_name': screenName},
      );

      debugPrint('Registration response: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final userSecret = data['user_secret'];

        await _storage.saveUserName(screenName);
        // Immediately login with the received user_secret
        final loginSuccess = await login(userSecret);
        if (!loginSuccess) {
          throw const AuthException('Login failed after registration');
        }

        return _currentUser!;
      }
      throw const AuthException('Registration failed');
    } catch (e) {
      debugPrint('Registration error: $e');
      throw AuthException(e.toString());
    }
  }

  Future<void> _fetchUserInfo() async {
    try {
      final response = await _apiClient.get(AppConfig.userEndpoint);
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data['screen_name'] != null) {
          await _storage.saveUserName(data['screen_name']);
        }

        _currentUser = _currentUser?.copyWith(
          screenName: data['screen_name'],
          // Add other fields as needed
        );
      }
    } catch (e) {
      debugPrint('Error fetching user info: $e');
    }
  }

  Future<void> logout() async {
    await _storage.clearSession();
    _currentUser = null;
    _apiClient.clearAuthToken();
  }

  Future<bool> restoreSession() async {
    try {
      final userSecret = await _storage.getUserSecret();
      debugPrint('Restoring session with stored secret: $userSecret');
      if (userSecret != null) {
        return login(userSecret);
      }
      return false;
    } catch (e) {
      debugPrint('Restore session error: $e');
      return false;
    }
  }

  Future<void> clear() async {
    await _storage.clearSession();
    // Add any other keys that need to be cleared
  }
}
