import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import 'chat_screen.dart';
import '../../../../core/providers/core_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule the auth check for the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAuth();
    });
  }

  Future<void> _handleAuth() async {
    final authNotifier = ref.read(authProvider.notifier);

    try {
      // Get the storage instance
      final storage = ref.read(sessionStorageProvider);

      // Check if we have a session
      if (storage.hasSession()) {
        // Try to restore existing session
        final hasSession = await authNotifier.checkAuth();

        if (!mounted) return;

        if (!hasSession) {
          // If restoration failed, clear session and register new user
          await storage.clearSession();
          await authNotifier.registerAndLogin();
        }
      } else {
        // No existing session, register new user
        await authNotifier.registerAndLogin();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (!mounted) return;

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

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 24),
            Text(
              'Flywall',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
