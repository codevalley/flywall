import 'package:dio/dio.dart';
import 'package:flywall/core/errors/failures.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  Future<dynamic> get(String path) async {
    try {
      final response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response.data;
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
}
