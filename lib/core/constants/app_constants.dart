import '../config/app_config.dart';
import '../config/environment_detector.dart';

/// Application-wide constants
class AppConstants {
  // App Configuration
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userPreferencesKey = 'user_preferences';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Environment-specific configuration
  static AppConfig get config => EnvironmentDetector.getConfig();

  // API Configuration (from environment config)
  static String get baseUrl => config.baseUrl;
  static Duration get apiTimeout => config.apiTimeout;
  static String get appName => config.appName;
  static String get apiKey => config.apiKey;
  static bool get isDebugMode => config.isDebugMode;
  static String get logLevel => config.logLevel;
  static bool get enableAnalytics => config.enableAnalytics;
  static bool get enableCrashReporting => config.enableCrashReporting;
  static String get databaseUrl => config.databaseUrl;
  static Map<String, String> get additionalHeaders => config.additionalHeaders;
}
