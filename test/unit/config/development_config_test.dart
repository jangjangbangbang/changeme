import 'package:flutter_test/flutter_test.dart';
import 'package:changeme/core/config/development_config.dart';
import 'package:changeme/core/config/environment.dart';

void main() {
  group('DevelopmentConfig', () {
    late DevelopmentConfig config;

    setUp(() {
      config = DevelopmentConfig();
    });

    test('should have correct environment', () {
      expect(config.environment, Environment.development);
    });

    test('should have correct app name', () {
      expect(config.appName, 'MyApp Dev');
    });

    test('should have correct base URL', () {
      expect(config.baseUrl, 'https://dev-api.example.com');
    });

    test('should have debug mode enabled', () {
      expect(config.isDebugMode, true);
    });

    test('should have correct API timeout', () {
      expect(config.apiTimeout, const Duration(seconds: 30));
    });

    test('should have correct log level', () {
      expect(config.logLevel, 'DEBUG');
    });

    test('should have analytics disabled', () {
      expect(config.enableAnalytics, false);
    });

    test('should have crash reporting disabled', () {
      expect(config.enableCrashReporting, false);
    });

    test('should have correct additional headers', () {
      expect(config.additionalHeaders, {
        'X-Environment': 'development',
        'X-Debug': 'true',
      });
    });
  });
}
