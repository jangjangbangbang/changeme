import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../constants/app_constants.dart';
import '../error/error_handler.dart';

/// HTTP client configuration and setup
class ApiClient {
  static final Logger _logger = Logger('ApiClient');
  late final Dio _dio;

  ApiClient() {
    _dio = Dio();
    _setupInterceptors();
  }

  /// Get the configured Dio instance
  Dio get dio => _dio;

  /// Setup interceptors for logging, error handling, etc.
  void _setupInterceptors() {
    _dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      sendTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Request interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.info('Request: ${options.method} ${options.uri}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.info(
            'Response: ${response.statusCode} ${response.requestOptions.uri}',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          _logger.severe('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );

    // Error interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final failure = ErrorHandler.handleException(error);
          _logger.severe('Handled error: ${failure.toString()}');
          handler.next(error);
        },
      ),
    );
  }
}
