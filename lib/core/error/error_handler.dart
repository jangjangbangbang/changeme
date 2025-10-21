import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Global error handler for the application
class ErrorHandler {
  static final Logger _logger = Logger('ErrorHandler');

  /// Converts exceptions to failures
  static Failure handleException(Exception exception) {
    _logger.severe('Exception occurred: $exception');

    if (exception is DioException) {
      return _handleDioException(exception);
    }

    if (exception is AppException) {
      return _handleAppException(exception);
    }

    return Failure.unknown(message: exception.toString());
  }

  /// Handles Dio-specific exceptions
  static Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(
          message: 'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.connectionError:
        return const Failure.network(
          message:
              'No internet connection. Please check your network settings.',
        );

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode;
        final message =
            exception.response?.data?['message'] ??
            exception.message ??
            'Server error occurred';
        return Failure.server(message: message, statusCode: statusCode);

      case DioExceptionType.cancel:
        return const Failure.network(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      default:
        return Failure.unknown(
          message: exception.message ?? 'Unknown network error occurred',
        );
    }
  }

  /// Handles application-specific exceptions
  static Failure _handleAppException(AppException exception) {
    if (exception is ServerException) {
      return Failure.server(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    } else if (exception is NetworkException) {
      return Failure.network(message: exception.message);
    } else if (exception is CacheException) {
      return Failure.cache(message: exception.message);
    } else if (exception is ValidationException) {
      return Failure.validation(
        message: exception.message,
        fieldErrors: exception.fieldErrors,
      );
    } else {
      return Failure.unknown(message: exception.message);
    }
  }
}
