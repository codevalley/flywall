// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/session_manager.dart';
import '../../domain/user.dart';
import '../../../../core/providers/core_providers.dart';

// Session manager provider
final sessionManagerProvider = Provider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final storage = ref.watch(sessionStorageProvider);
  return SessionManager(apiClient, storage);
});

// Auth state
enum AuthStatus { initial, loading, authenticated, error }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SessionManager _sessionManager;

  AuthNotifier(this._sessionManager) : super(const AuthState());

  void setAuthenticated(User user) {
    state = AuthState(
      status: AuthStatus.authenticated,
      user: user,
    );
  }

  Future<bool> checkAuth([String? secret]) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      // If secret is provided, use it for restoration
      final success = secret != null
          ? await _sessionManager.restoreWithSecret(secret)
          : await _sessionManager.restoreSession();

      if (success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: _sessionManager.currentUser,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          error: 'Invalid secret or session expired',
        );
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<void> registerAndLogin(String name) async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final user = await _sessionManager.register(name);
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await _sessionManager.logout();
    state = const AuthState(status: AuthStatus.initial);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final sessionManager = ref.watch(sessionManagerProvider);
  return AuthNotifier(sessionManager);
});
