import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../route_paths.dart';

/// App shell with bottom navigation
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;
  static const _tabs = [P.home, P.search, P.profile];

  int _indexFor(String loc) => loc.startsWith(P.search)
      ? 1
      : loc.startsWith(P.profile)
      ? 2
      : 0;

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
