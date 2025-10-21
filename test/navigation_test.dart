import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:changeme/app/providers.dart';
import 'package:changeme/features/auth/login_screen.dart';

void main() {
  testWidgets('unauthenticated → /login', (tester) async {
    // Start in logged-out state
    final app = ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(goRouterProvider);
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('authenticated → /home', (tester) async {
    // Create a custom provider override for authenticated state
    final app = ProviderScope(
      overrides: [isLoggedInProvider.overrideWith((ref) => true)],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(goRouterProvider);
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    // Should show home screen with bottom navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
