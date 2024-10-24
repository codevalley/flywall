import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/data/datasources/token_manager.dart';
import 'package:flywall/presentation/providers/auth/auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final TokenManager _tokenManager;

  AuthNotifier(this._tokenManager) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    try {
      final token = await _tokenManager.getToken();
      if (token != null) {
        state = const AuthState.authenticated();
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
