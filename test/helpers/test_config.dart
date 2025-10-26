import 'package:changeme/core/config/app_config.dart';
import 'package:changeme/core/config/environment.dart';

/// Test configuration for unit and widget tests
class TestConfig implements AppConfig {
  @override
  Environment get environment => Environment.development;

  @override
  String get appName => 'Test App';

  @override
  String get baseUrl => 'https://test-api.example.com';

  @override
  String get apiKey => 'test-api-key';

  @override
  bool get isDebugMode => true;

  @override
  Duration get apiTimeout => const Duration(seconds: 5);

  @override
  String get logLevel => 'DEBUG';

  @override
  bool get enableAnalytics => false;

  @override
  bool get enableCrashReporting => false;

  @override
  String get databaseUrl => 'sqlite://test.db';

  @override
  Map<String, String> get additionalHeaders => {
    'X-Environment': 'test',
    'X-Test': 'true',
  };
}

/// Development test configuration
class DevelopmentTestConfig implements AppConfig {
  @override
  Environment get environment => Environment.development;

  @override
  String get appName => 'Test App Dev';

  @override
  String get baseUrl => 'https://test-dev-api.example.com';

  @override
  String get apiKey => 'test-dev-api-key';

  @override
  bool get isDebugMode => true;

  @override
  Duration get apiTimeout => const Duration(seconds: 10);

  @override
  String get logLevel => 'DEBUG';

  @override
  bool get enableAnalytics => false;

  @override
  bool get enableCrashReporting => false;

  @override
  String get databaseUrl => 'sqlite://test-dev.db';

  @override
  Map<String, String> get additionalHeaders => {
    'X-Environment': 'test-development',
    'X-Test': 'true',
  };
}
