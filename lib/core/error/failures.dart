import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base class for all failures in the application
@freezed
class Failure with _$Failure {
  const factory Failure.server({required String message, int? statusCode}) =
      ServerFailure;

  const factory Failure.network({required String message}) = NetworkFailure;

  const factory Failure.cache({required String message}) = CacheFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;

  const factory Failure.unknown({required String message}) = UnknownFailure;
}

/// Extension to get user-friendly error messages
extension FailureExtension on Failure {
  String get userMessage {
    return when(
      server: (message, statusCode) => 'Server error: $message',
      network: (message) => 'Network error: $message',
      cache: (message) => 'Cache error: $message',
      validation: (message, fieldErrors) => 'Validation error: $message',
      unknown: (message) => 'Unknown error: $message',
    );
  }
}
