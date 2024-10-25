// test/helpers/test_helpers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/core/network/api_client.dart';
import 'package:flywall/core/storage/session_storage.dart';
import 'package:flywall/core/providers/core_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget with necessary providers for testing
Widget wrapWithProviders(
  Widget widget, {
  ApiClient? apiClient,
  SessionStorage? sessionStorage,
}) {
  return ProviderScope(
    overrides: [
      if (apiClient != null) apiClientProvider.overrideWithValue(apiClient),
      if (sessionStorage != null)
        sessionStorageProvider.overrideWithValue(sessionStorage),
    ],
    child: MaterialApp(home: widget),
  );
}

/// Creates a mock response for testing
Response<T> createMockResponse<T>({
  required T data,
  int statusCode = 200,
  String path = '/',
}) {
  return Response(
    data: data,
    statusCode: statusCode,
    requestOptions: RequestOptions(path: path),
  );
}

/// Pumps the widget and waits for all animations and microtasks
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  bool timerDone = false;
  final timer = Future.delayed(timeout, () => timerDone = true);

  while (!timerDone) {
    await tester.pump(const Duration(milliseconds: 50));

    final found = tester.any(finder);
    if (found) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 50));
  }

  throw Exception('Finder not found within timeout: $finder');
}
