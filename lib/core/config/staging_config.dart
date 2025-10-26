import 'app_config.dart';
import 'environment.dart';

/// Staging environment configuration
class StagingConfig implements AppConfig {
  @override
  Environment get environment => Environment.staging;

  @override
  String get appName => 'MyApp Staging';

  @override
  String get baseUrl => 'https://staging-api.example.com';

  @override
  String get apiKey => 'staging-api-key-67890';

  @override
  bool get isDebugMode => false;

  @override
  Duration get apiTimeout => const Duration(seconds: 15);

  @override
  String get logLevel => 'INFO';

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get databaseUrl => 'postgresql://staging-db.example.com';

  @override
  Map<String, String> get additionalHeaders => {
    'X-Environment': 'staging',
    'X-Version': '1.0.0',
  };
}
