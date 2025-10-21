import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';

/// Helper class for navigation using go_router
class NavigationHelper {
  /// Navigate to home screen
  static void goHome(BuildContext context) {
    context.go(AppRouter.homePath);
  }

  /// Navigate to user detail screen
  static void goToUserDetail(BuildContext context, int userId) {
    context.go('/user/$userId');
  }

  /// Navigate to user detail screen with push (adds to navigation stack)
  static void pushToUserDetail(BuildContext context, int userId) {
    context.push('/user/$userId');
  }

  /// Go back to previous screen
  static void goBack(BuildContext context) {
    context.pop();
  }

  /// Check if we can go back
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }
}
