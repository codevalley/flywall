// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/main.dart';
import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/core/storage/session_storage.dart';
import 'package:flywall/core/providers/core_providers.dart';
import 'package:dio/dio.dart';

// Mock implementations
class MockApiClient extends ApiClient {
  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (path.contains('/auth/register')) {
      return Response(
        data: {
          'id': 'test_id',
          'screen_name': 'test_user',
          'access_token': 'test_token',
          'user_secret': 'test_secret',
        } as T,
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }
    if (path.contains('/auth/token')) {
      return Response(
        data: {
          'id': 'test_id',
          'screen_name': 'test_user',
          'access_token': 'test_token',
        } as T,
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }
    throw UnimplementedError();
  }
}

class MockSessionStorage extends SessionStorage {
  @override
  Future<void> init() async {}

  @override
  Future<void> saveUserSecret(String secret) async {}

  @override
  Future<String?> getUserSecret() async => null;

  @override
  bool hasSession() => false;
}

void main() {
  testWidgets('App initializes and shows splash screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame with mock providers
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(MockApiClient()),
          sessionStorageProvider.overrideWithValue(MockSessionStorage()),
        ],
        child: const FlywallApp(),
      ),
    );

    // Verify that splash screen is shown initially
    expect(find.text('Flywall'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Allow async operations to complete
    await tester.pumpAndSettle();

    // After initialization, we should be on the chat screen
    // since our mock auth flow automatically registers/logs in
    expect(find.byType(TextField), findsOneWidget); // Search input
  });

  testWidgets('Search input is enabled when not loading',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(MockApiClient()),
          sessionStorageProvider.overrideWithValue(MockSessionStorage()),
        ],
        child: const FlywallApp(),
      ),
    );

    // Wait for initialization
    await tester.pumpAndSettle();

    // Find the search input
    final searchInput = find.byType(TextField);
    expect(searchInput, findsOneWidget);

    // Verify the search input is enabled
    final TextField textField = tester.widget(searchInput);
    expect(textField.enabled, isTrue);
  });

  testWidgets('Shows error message on network failure',
      (WidgetTester tester) async {
    final mockApiClient = MockApiClient();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiClientProvider.overrideWithValue(mockApiClient),
          sessionStorageProvider.overrideWithValue(MockSessionStorage()),
        ],
        child: const FlywallApp(),
      ),
    );

    // Allow the error to show
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify error handling
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
