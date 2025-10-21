import 'package:dartz/dartz.dart' as dartz;

import '../error/failures.dart';

/// Abstract base class for all use cases
abstract class UseCase<T, Params> {
  Future<dartz.Either<Failure, T>> call(Params params);
}

/// Abstract base class for use cases that don't require parameters
abstract class UseCaseNoParams<T> {
  Future<dartz.Either<Failure, T>> call();
}

/// No parameters class for use cases that don't need parameters
class NoParams {
  const NoParams();
}
