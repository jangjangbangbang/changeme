import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';
import 'route_paths.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/home/detail_screen.dart';
import '../features/search/search_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/profile/settings_screen.dart';
import 'widgets/app_shell.dart';

// 1) Core repos/services
final authRepoProvider = Provider<AuthRepository>((ref) {
  final repo = AuthRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

// 2) Derived auth state
final authStateStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(authRepoProvider).authStateChanges();
});

final isLoggedInProvider = Provider<bool>((ref) {
  // initial value = false until first event
  final asyncState = ref.watch(authStateStreamProvider);
  return asyncState.maybeWhen(data: (v) => v, orElse: () => false);
});

// Small helper to make a Listenable from a Stream for go_router.refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// 3) The GoRouter itself, exposed as a provider
final goRouterProvider = Provider<GoRouter>((ref) {
  final repo = ref.watch(authRepoProvider);
  final refreshListenable = GoRouterRefreshStream(
    ref.watch(authStateStreamProvider.stream),
  );
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    initialLocation: P.home,
    debugLogDiagnostics: true, // dev only
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final loggedIn = repo.isLoggedIn; // fast synchronous read
      final atLogin = state.matchedLocation == P.login;
      if (!loggedIn && !atLogin) return P.login;
      if (loggedIn && atLogin) return P.home;
      return null;
    },
    routes: [
      GoRoute(
        name: R.login,
        path: P.login,
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(
            name: R.home,
            path: P.home,
            pageBuilder: (_, __) => const NoTransitionPage(child: HomeScreen()),
            routes: [
              GoRoute(
                name: R.detail,
                path: P.detail, // /home/detail/:postId
                builder: (_, s) =>
                    DetailScreen(postId: s.pathParameters['postId']!),
              ),
            ],
          ),
          GoRoute(
            name: R.search,
            path: P.search,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            name: R.profile,
            path: P.profile,
            pageBuilder: (_, __) =>
                const NoTransitionPage(child: ProfileScreen()),
            routes: [
              GoRoute(
                name: R.settings,
                path: P.settings, // /profile/settings
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text('404: ${state.error}')),
    ),
  );
});
