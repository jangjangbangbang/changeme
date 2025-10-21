import 'package:freezed_annotation/freezed_annotation.dart';

import '../error/failures.dart';

part 'result.freezed.dart';

/// Generic result type for handling success and failure states
@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = FailureResult<T>;
}

/// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  /// Returns true if the result is a success
  bool get isSuccess => this is Success<T>;

  /// Returns true if the result is a failure
  bool get isFailure => this is FailureResult<T>;

  /// Returns the data if success, null otherwise
  T? get data => when(success: (data) => data, failure: (_) => null);

  /// Returns the failure if failure, null otherwise
  Failure? get failure =>
      when(success: (_) => null, failure: (failure) => failure);

  /// Maps the data if success, otherwise returns the failure
  Result<R> map<R>(R Function(T) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Executes a function based on the result type
  R when<R>({
    required R Function(T) success,
    required R Function(Failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as FailureResult<T>).failure);
    }
  }
}
