import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/presentation/providers/providers.dart';
import 'package:flywall/presentation/theme/app_theme.dart';
import 'package:flywall/presentation/pages/home_page.dart';

void main() async {
  try {
    print('App starting...');
    WidgetsFlutterBinding.ensureInitialized();
    print('Flutter binding initialized');

    final container = ProviderContainer();
    print('ProviderContainer created');

    final tokenManager = container.read(tokenManagerProvider);
    print('TokenManager retrieved');

    await tokenManager.init();
    print('TokenManager initialized');

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    print('App running');
  } catch (e, stackTrace) {
    print('Error during app initialization: $e');
    print('Stack trace: $stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flywall',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
