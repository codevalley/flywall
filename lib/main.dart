// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/storage/session_storage.dart';
import 'core/network/api_client.dart';
import 'core/theme/theme.dart'; // Import our new theme
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
        theme: AppTheme.darkTheme, // Use our dark theme for error screen
        home: Scaffold(
          backgroundColor: AppColors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.yellow,
                    size: 64,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to initialize app',
                    style: AppTypography.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: AppTypography.body.copyWith(
                      color: AppColors.yellow,
                    ),
                    textAlign: TextAlign.center,
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
      title: 'Sidekick',
      theme: AppTheme.darkTheme, // Use our new theme
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: authState.status == AuthStatus.authenticated
          ? const ChatScreen()
          : const SplashScreen(),
    );
  }
}
