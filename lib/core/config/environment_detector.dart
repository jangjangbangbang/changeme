import 'app_config.dart';
import 'development_config.dart';
import 'staging_config.dart';
import 'production_config.dart';
import 'environment.dart';

/// Environment detection and configuration factory
class EnvironmentDetector {
  /// Get current environment from compile-time constants
  static Environment get currentEnvironment {
    const environment = String.fromEnvironment(
      'ENVIRONMENT',
      defaultValue: 'development',
    );

    switch (environment.toLowerCase()) {
      case 'development':
        return Environment.development;
      case 'staging':
        return Environment.staging;
      case 'production':
        return Environment.production;
      default:
        return Environment.development;
    }
  }

  /// Get configuration for current environment
  static AppConfig getConfig() {
    switch (currentEnvironment) {
      case Environment.development:
        return DevelopmentConfig();
      case Environment.staging:
        return StagingConfig();
      case Environment.production:
        return ProductionConfig();
    }
  }

  /// Get configuration for specific environment
  static AppConfig getConfigForEnvironment(Environment environment) {
    switch (environment) {
      case Environment.development:
        return DevelopmentConfig();
      case Environment.staging:
        return StagingConfig();
      case Environment.production:
        return ProductionConfig();
    }
  }
}
