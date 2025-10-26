import 'environment.dart';

/// Abstract configuration interface for environment-specific settings
abstract class AppConfig {
  Environment get environment;
  String get appName;
  String get baseUrl;
  String get apiKey;
  bool get isDebugMode;
  Duration get apiTimeout;
  String get logLevel;
  bool get enableAnalytics;
  bool get enableCrashReporting;
  String get databaseUrl;
  Map<String, String> get additionalHeaders;
}
