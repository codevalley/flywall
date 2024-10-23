import 'package:dartz/dartz.dart';
import 'package:flywall/core/errors/failures.dart';
import 'package:flywall/domain/entities/auth/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register(String screenName);
  Future<Either<Failure, User>> login(String token);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, String>> refreshToken();
}
