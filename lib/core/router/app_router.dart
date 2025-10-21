import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/user/presentation/screens/user_list_screen.dart';
import '../../features/user/presentation/screens/user_detail_screen.dart';

/// Application router configuration using go_router
class AppRouter {
  static const String homePath = '/';
  static const String userDetailPath = '/user/:userId';

  /// Router configuration
  static final GoRouter router = GoRouter(
    initialLocation: homePath,
    routes: [
      GoRoute(
        path: homePath,
        name: 'home',
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: userDetailPath,
        name: 'user-detail',
        builder: (context, state) {
          final userIdString = state.pathParameters['userId'];
          if (userIdString == null) {
            return const _InvalidRouteScreen(message: 'User ID is required');
          }

          final userId = int.tryParse(userIdString);
          if (userId == null) {
            return const _InvalidRouteScreen(message: 'Invalid user ID format');
          }

          return UserDetailScreen(userId: userId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found: ${state.uri.path}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(homePath),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Screen displayed when route parameters are invalid
class _InvalidRouteScreen extends StatelessWidget {
  final String message;

  const _InvalidRouteScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invalid Route'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_outlined, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.homePath),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
