import 'package:flutter_test/flutter_test.dart';
import 'package:changeme/core/config/staging_config.dart';
import 'package:changeme/core/config/environment.dart';

void main() {
  group('StagingConfig', () {
    late StagingConfig config;

    setUp(() {
      config = StagingConfig();
    });

    test('should have correct environment', () {
      expect(config.environment, Environment.staging);
    });

    test('should have correct app name', () {
      expect(config.appName, 'MyApp Staging');
    });

    test('should have correct base URL', () {
      expect(config.baseUrl, 'https://staging-api.example.com');
    });

    test('should have debug mode disabled', () {
      expect(config.isDebugMode, false);
    });

    test('should have correct API timeout', () {
      expect(config.apiTimeout, const Duration(seconds: 15));
    });

    test('should have correct log level', () {
      expect(config.logLevel, 'INFO');
    });

    test('should have analytics enabled', () {
      expect(config.enableAnalytics, true);
    });

    test('should have crash reporting enabled', () {
      expect(config.enableCrashReporting, true);
    });

    test('should have correct additional headers', () {
      expect(config.additionalHeaders, {
        'X-Environment': 'staging',
        'X-Version': '1.0.0',
      });
    });
  });
}
