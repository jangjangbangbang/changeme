import 'app_config.dart';
import 'environment.dart';

/// Development environment configuration
class DevelopmentConfig implements AppConfig {
  @override
  Environment get environment => Environment.development;

  @override
  String get appName => 'MyApp Dev';

  @override
  String get baseUrl => 'https://dev-api.example.com';

  @override
  String get apiKey => 'dev-api-key-12345';

  @override
  bool get isDebugMode => true;

  @override
  Duration get apiTimeout => const Duration(seconds: 30);

  @override
  String get logLevel => 'DEBUG';

  @override
  bool get enableAnalytics => false;

  @override
  bool get enableCrashReporting => false;

  @override
  String get databaseUrl => 'sqlite://dev.db';

  @override
  Map<String, String> get additionalHeaders => {
    'X-Environment': 'development',
    'X-Debug': 'true',
  };
}
