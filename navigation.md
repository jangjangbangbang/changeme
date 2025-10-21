# Flutter Navigation Implementation Guide
## go_router + Riverpod Setup Instructions

This guide provides step-by-step instructions to implement a production-ready navigation system using go_router with Flutter Riverpod.

## Overview
- **Goal**: Declarative, URL-driven navigation that works on mobile and web
- **Features**: Auth redirects, deep links, bottom-tab shells, typed routes
- **Architecture**: Single source of truth for auth via Riverpod providers

## Step 1: Update Dependencies

Update `pubspec.yaml` with required dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
  flutter_riverpod: ^2.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  go_router_builder: ^2.7.0  # Optional for typed routes
  build_runner: ^2.4.0       # Optional for typed routes
```

## Step 2: Create Project Structure

Create the following directory structure:

```
lib/
  app/
    route_paths.dart
    providers.dart
    widgets/
      app_shell.dart
  data/
    auth_repository.dart
  features/
    auth/
      login_screen.dart
    home/
      home_screen.dart
      detail_screen.dart
    search/
      search_screen.dart
    profile/
      profile_screen.dart
      settings_screen.dart
  main.dart
```

## Step 3: Implement Route Names and Paths

Create `lib/app/route_paths.dart`:

```dart
class R {
  static const login = 'login';
  static const home = 'home';
  static const search = 'search';
  static const profile = 'profile';
  static const detail = 'detail';
  static const settings = 'settings';
}

class P {
  static const login = '/login';
  static const home = '/home';
  static const search = '/search';
  static const profile = '/profile';
  static const detail = 'detail/:postId'; // nested under /home
  static const settings = 'settings';     // nested under /profile
}
```

## Step 4: Create Auth Repository

Create `lib/data/auth_repository.dart`:

```dart
import 'dart:async';

class AuthRepository {
  final _ctrl = StreamController<bool>.broadcast();
  bool _isLoggedIn = false;

  Stream<bool> authStateChanges() => _ctrl.stream;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signIn() async {
    _isLoggedIn = true;
    _ctrl.add(true);
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _ctrl.add(false);
  }

  void dispose() {
    _ctrl.close();
  }
}
```

## Step 5: Create Riverpod Providers

Create `lib/app/providers.dart`:

```dart
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
                builder: (_, s) => DetailScreen(postId: s.pathParameters['postId']!),
              ),
            ],
          ),
          GoRoute(
            name: R.search,
            path: P.search,
            pageBuilder: (_, __) => const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            name: R.profile,
            path: P.profile,
            pageBuilder: (_, __) => const NoTransitionPage(child: ProfileScreen()),
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
```

## Step 6: Create App Shell (Bottom Navigation)

Create `lib/app/widgets/app_shell.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;
  static const _tabs = [P.home, P.search, P.profile];

  int _indexFor(String loc) =>
      loc.startsWith(P.search) ? 1 : loc.startsWith(P.profile) ? 2 : 0;

  @override
  Widget build(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    final index = _indexFor(loc);
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => context.go(_tabs[i]),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

## Step 7: Create Feature Screens

### Login Screen
Create `lib/features/auth/login_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => ref.read(authRepoProvider).signIn(),
          child: const Text('Sign in'),
        ),
      ),
    );
  }
}
```

### Home Screen
Create `lib/features/home/home_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/route_paths.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Home!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/home/detail/42'),
              child: const Text('View Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Detail Screen
Create `lib/features/home/detail_screen.dart`:

```dart
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.postId});
  final String postId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail $postId')),
      body: Center(
        child: Text('Post ID: $postId'),
      ),
    );
  }
}
```

### Search Screen
Create `lib/features/search/search_screen.dart`:

```dart
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: Text('Search Screen'),
      ),
    );
  }
}
```

### Profile Screen
Create `lib/features/profile/profile_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/providers.dart';
import '../../app/route_paths.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Profile Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.push('/profile/settings'),
              child: const Text('Settings'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref.read(authRepoProvider).signOut(),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Settings Screen
Create `lib/features/profile/settings_screen.dart`:

```dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}
```

## Step 8: Update Main App

Update `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'App',
      theme: ThemeData(useMaterial3: true),
      routerConfig: router,
    );
  }
}
```

## Step 9: Navigation Usage Examples

### Basic Navigation
```dart
// Navigate to home
context.go(P.home);

// Navigate to detail with parameter
context.push('/home/detail/42');

// Read query parameters
final q = GoRouterState.of(context).uri.queryParameters['q'];

// Pass complex objects
context.push('/home/detail/42', extra: Post(...));
final post = state.extra as Post?;
```

## Step 10: Testing (Optional)

Create `test/navigation_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:your_app/app/providers.dart';
import 'package:your_app/features/auth/login_screen.dart';

void main() {
  testWidgets('unauthenticated → /login', (tester) async {
    // Start in logged-out state
    final app = ProviderScope(
      child: Consumer(builder: (context, ref, _) {
        final router = ref.watch(goRouterProvider);
        return MaterialApp.router(routerConfig: router);
      }),
    );
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
```

## Step 11: Optional - Typed Routes

If you want typed routes, create `lib/app/typed_routes.dart`:

```dart
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';
part 'typed_routes.g.dart';

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData {
  const HomeRoute();
  @override
  Widget build(BuildContext c, GoRouterState s) => const Placeholder();
}

@TypedGoRoute<HomeDetailRoute>(path: '/home/detail/:postId')
class HomeDetailRoute extends GoRouteData {
  const HomeDetailRoute({required this.postId});
  final String postId;
  @override
  Widget build(BuildContext c, GoRouterState s) => const Placeholder();
}
```

Then run:
```bash
flutter pub run build_runner build -d
```

## Best Practices

1. **Keep the router in a Riverpod provider**; read it in MaterialApp.router
2. **redirect must be fast & synchronous**; store an eager boolean (repo.isLoggedIn) for that
3. **Use a refresh Listenable** driven by a stream (e.g., Firebase auth, your repo)
4. **Use NoTransitionPage at tab roots** to avoid jank
5. **Prefer goNamed()** for analytics-stable identifiers
6. **Disable debugLogDiagnostics** in production

## Testing the Implementation

1. Run `flutter pub get` to install dependencies
2. Run `flutter run` to start the app
3. You should see the login screen initially
4. Click "Sign in" to navigate to the home screen with bottom navigation
5. Test navigation between tabs and to detail/settings screens
6. Test sign out functionality

This implementation provides a complete, production-ready navigation system with authentication, deep linking, and a clean architecture using Riverpod and go_router.
