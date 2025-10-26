import 'app_config.dart';
import 'environment.dart';

/// Production environment configuration
class ProductionConfig implements AppConfig {
  @override
  Environment get environment => Environment.production;

  @override
  String get appName => 'MyApp';

  @override
  String get baseUrl => 'https://api.example.com';

  @override
  String get apiKey => 'prod-api-key-abcdef';

  @override
  bool get isDebugMode => false;

  @override
  Duration get apiTimeout => const Duration(seconds: 10);

  @override
  String get logLevel => 'WARNING';

  @override
  bool get enableAnalytics => true;

  @override
  bool get enableCrashReporting => true;

  @override
  String get databaseUrl => 'postgresql://prod-db.example.com';

  @override
  Map<String, String> get additionalHeaders => {
    'X-Environment': 'production',
    'X-Version': '1.0.0',
  };
}
