import 'package:dio/dio.dart';
import 'package:flywall/core/config/app_config.dart';
import 'package:flywall/core/errors/failures.dart';

class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options.baseUrl = AppConfig.baseUrl + AppConfig.apiPath;
    // You can add more default configurations here, like headers, timeouts, etc.
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get<T>(path,
          queryParameters: queryParameters, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post<T>(path,
          data: data, queryParameters: queryParameters, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put<T>(path,
          data: data, queryParameters: queryParameters, options: options);
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await dio.delete(path,
          queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network('Network timeout');
      case DioExceptionType.badResponse:
        return Failure.server('Server error: ${error.response?.statusCode}');
      default:
        return const Failure.unexpected('An unexpected error occurred');
    }
  }

  // Implement other HTTP methods as needed...
}
