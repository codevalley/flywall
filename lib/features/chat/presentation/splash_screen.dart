import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'chat_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleAuth();
  }

  Future<void> _handleAuth() async {
    final authNotifier = ref.read(authProvider.notifier);

    // Try to restore session first
    final hasSession = await authNotifier.checkAuth();
    if (!mounted) return;

    if (!hasSession) {
      // If no session, register new user
      await authNotifier.registerAndLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'An error occurred')),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100), // Replace with your app logo
            const SizedBox(height: 24),
            const Text(
              'Flywall',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
