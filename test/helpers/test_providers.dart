import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_config.dart';
import 'package:changeme/core/config/app_config.dart';
import 'package:changeme/core/config/environment.dart';

/// Test providers for dependency injection in tests
final testConfigProvider = Provider<AppConfig>((ref) {
  return TestConfig();
});

final testEnvironmentProvider = Provider<Environment>((ref) {
  return ref.watch(testConfigProvider).environment;
});

final testBaseUrlProvider = Provider<String>((ref) {
  return ref.watch(testConfigProvider).baseUrl;
});

final testIsDebugModeProvider = Provider<bool>((ref) {
  return ref.watch(testConfigProvider).isDebugMode;
});

/// Development test providers
final developmentTestConfigProvider = Provider<AppConfig>((ref) {
  return DevelopmentTestConfig();
});

final developmentTestEnvironmentProvider = Provider<Environment>((ref) {
  return ref.watch(developmentTestConfigProvider).environment;
});
