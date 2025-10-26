import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_providers.dart';
import 'package:changeme/core/config/app_config.dart';

/// Test setup and teardown utilities
class TestSetup {
  static void setupAll() {
    TestWidgetsFlutterBinding.ensureInitialized();
  }

  static void setup() {
    // Set up test environment
    // This would typically involve setting up mocks and test data
  }

  static void teardown() {
    // Clean up test environment
    // This would typically involve cleaning up mocks and test data
  }
}

/// Test utilities for creating test widgets with providers
class TestUtils {
  static Widget createTestWidget({
    required Widget child,
    AppConfig? config,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        if (config != null) testConfigProvider.overrideWithValue(config),
        ...overrides,
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  static Future<void> enterTextAndSettle(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }
}
