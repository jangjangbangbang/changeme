import 'package:flutter_test/flutter_test.dart';
import 'package:changeme/core/config/production_config.dart';
import 'package:changeme/core/config/environment.dart';

void main() {
  group('ProductionConfig', () {
    late ProductionConfig config;

    setUp(() {
      config = ProductionConfig();
    });

    test('should have correct environment', () {
      expect(config.environment, Environment.production);
    });

    test('should have correct app name', () {
      expect(config.appName, 'MyApp');
    });

    test('should have correct base URL', () {
      expect(config.baseUrl, 'https://api.example.com');
    });

    test('should have debug mode disabled', () {
      expect(config.isDebugMode, false);
    });

    test('should have correct API timeout', () {
      expect(config.apiTimeout, const Duration(seconds: 10));
    });

    test('should have correct log level', () {
      expect(config.logLevel, 'WARNING');
    });

    test('should have analytics enabled', () {
      expect(config.enableAnalytics, true);
    });

    test('should have crash reporting enabled', () {
      expect(config.enableCrashReporting, true);
    });

    test('should have correct additional headers', () {
      expect(config.additionalHeaders, {
        'X-Environment': 'production',
        'X-Version': '1.0.0',
      });
    });
  });
}
