// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;
  String? _userSecret;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  ApiClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      validateStatus: (status) => status != null && status < 500,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401 && _userSecret != null) {
          // Token expired, attempt to refresh
          final reqOptions = e.requestOptions;
          
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              // Try to get a new token using the stored secret
              final response = await _dio.post(
                AppConfig.tokenEndpoint,
                data: {'user_secret': _userSecret},
                options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                ),
              );

              if (response.statusCode == 200) {
                final newToken = response.data['access_token'];
                setAuthToken(newToken);
                
                // Retry the original request with new token
                reqOptions.headers['Authorization'] = 'Bearer $newToken';
                
                // Retry all pending requests
                final requests = [..._pendingRequests];
                _pendingRequests.clear();
                for (final pendingRequest in requests) {
                  pendingRequest.headers['Authorization'] = 'Bearer $newToken';
                  _dio.fetch(pendingRequest);
                }
                
                // Resolve the original failed request
                return handler.resolve(await _dio.fetch(reqOptions));
              }
            } catch (refreshError) {
              // Token refresh failed
              return handler.next(DioException(
                requestOptions: reqOptions,
                error: 'Session expired. Please login again.',
                type: DioExceptionType.badResponse,
              ));
            } finally {
              _isRefreshing = false;
            }
          } else {
            // Add to pending requests if currently refreshing
            _pendingRequests.add(reqOptions);
          }
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          if (e.requestOptions.extra['retryCount'] == null ||
              e.requestOptions.extra['retryCount'] < 3) {
            final options = e.requestOptions;
            options.extra['retryCount'] =
                (options.extra['retryCount'] ?? 0) + 1;
            return handler.resolve(await _dio.fetch(options));
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkException(AppConfig.networkErrorMessage);

      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return const AuthException(AppConfig.authErrorMessage);
        }
        return NetworkException(
            e.response?.statusMessage ?? AppConfig.serverErrorMessage);

      default:
        return const NetworkException(AppConfig.networkErrorMessage);
    }
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void setUserSecret(String secret) {
    _userSecret = secret;
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    _userSecret = null;
  }
}
