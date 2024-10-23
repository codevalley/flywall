import 'package:flywall/data/datasources/token_manager.dart';
import 'package:flywall/domain/entities/auth/user.dart';

class SessionManager {
  final TokenManager _tokenManager;
  User? _currentUser;

  SessionManager(this._tokenManager);

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    await _tokenManager.saveToken(user.token);
  }

  User? get currentUser => _currentUser;

  Future<bool> isLoggedIn() async {
    final token = await _tokenManager.getToken();
    return token != null;
  }

  Future<void> clearSession() async {
    _currentUser = null;
    await _tokenManager.deleteToken();
  }
}
