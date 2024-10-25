// lib/core/providers/core_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_client.dart';
import '../storage/session_storage.dart';

/// Core API client provider
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

/// Session storage provider
final sessionStorageProvider =
    Provider<SessionStorage>((ref) => SessionStorage());
