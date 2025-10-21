/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // App Configuration
  static const String appName = 'Clean Architecture Demo';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userPreferencesKey = 'user_preferences';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
