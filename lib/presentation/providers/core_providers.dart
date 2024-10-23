import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flywall/core/network/api_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(); // You can configure Dio here if needed
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});
