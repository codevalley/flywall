import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/storage/session_storage.dart';
import 'features/chat/presentation/chat_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/chat/presentation/splash_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    final sessionStorage = SessionStorage();
    await sessionStorage.init();

    runApp(
      ProviderScope(
        child: FlywallApp(),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Error during app initialization: $e');
    debugPrint('Stack trace: $stackTrace');
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
