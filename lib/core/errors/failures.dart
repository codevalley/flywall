import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flywall/core/errors/exceptions.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server([String? message]) = ServerFailure;
  const factory Failure.network([String? message]) = NetworkFailure;
  const factory Failure.cache([String? message]) = CacheFailure;
  const factory Failure.validation([String? message]) = ValidationFailure;
  const factory Failure.unexpected([String? message]) = UnexpectedFailure;

  static Failure fromException(Exception e) {
    if (e is ServerException) {
      return Failure.server(e.message);
    } else if (e is NetworkException) {
      return Failure.network(e.message);
    } else if (e is CacheException) {
      return Failure.cache(e.message);
    } else if (e is ValidationException) {
      return Failure.validation(e.message);
    } else {
      return Failure.unexpected(e.toString());
    }
  }
}
