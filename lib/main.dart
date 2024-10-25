// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/storage/session_storage.dart';
import 'core/network/api_client.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/chat/presentation/splash_screen.dart';
import 'core/providers/core_providers.dart';

void main() async {
  try {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Hive
    await Hive.initFlutter();

    // Initialize session storage
    final sessionStorage = SessionStorage();
    await sessionStorage.init();

    // Initialize API client
    final apiClient = ApiClient();

    // Run app with providers
    runApp(
      ProviderScope(
        overrides: [
          // Override the API client provider with our initialized instance
          apiClientProvider.overrideWithValue(apiClient),
          // Override the session storage provider with our initialized instance
          sessionStorageProvider.overrideWithValue(sessionStorage),
        ],
        child: const FlywallApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');

    // Show error UI if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlywallApp extends ConsumerWidget {
  const FlywallApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Flywall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: authState.status == AuthStatus.authenticated
          ? const ChatScreen()
          : const SplashScreen(),
    );
  }
}
