// presentation/pages/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/presentation/providers/providers.dart';
import 'package:flywall/presentation/providers/auth/auth_state.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    print('SplashPage: initState');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('SplashPage: Post-frame callback');
      ref.read(authProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('SplashPage: build');
    ref.listen<AuthState>(authProvider, (previous, next) {
      print('SplashPage: AuthState listener triggered');
      print('Previous state: $previous');
      print('Next state: $next');
      next.when(
        initial: () => print('AuthState: initial'),
        authenticated: () {
          print('AuthState: authenticated - Navigating to home');
          Navigator.pushReplacementNamed(context, '/home');
        },
        unauthenticated: () {
          print('AuthState: unauthenticated - Navigating to home');
          Navigator.pushReplacementNamed(context, '/home');
        },
        error: (message) {
          print('AuthState: error - $message');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
