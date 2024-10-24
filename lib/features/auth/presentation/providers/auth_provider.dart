import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/session_manager.dart';
import '../../domain/user.dart';
import '../../../../core/storage/session_storage.dart';

// Core providers
final dioProvider = Provider((ref) => Dio());
final sessionStorageProvider = Provider((ref) => SessionStorage());
final sessionManagerProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(sessionStorageProvider);
  return SessionManager(dio, storage);
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

  Future<bool> checkAuth() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      final success = await _sessionManager.restoreSession();
      if (success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: _sessionManager.currentUser,
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

  Future<void> registerAndLogin() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      // Generate a random screen name (or handle it as per your requirement)
      final screenName = 'user_${DateTime.now().millisecondsSinceEpoch}';

      // Register new user
      final user = await _sessionManager.register(screenName);

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
