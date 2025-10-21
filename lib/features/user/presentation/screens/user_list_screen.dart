import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_state_providers.dart';
import '../widgets/user_card.dart';
import '../widgets/user_list_loading.dart';
import '../widgets/user_list_error.dart';
import 'user_detail_screen.dart';

/// Screen displaying a list of users
class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // Load users when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userListStateProvider.notifier).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userListState = ref.watch(userListStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(userListStateProvider.notifier).refreshUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(context, ref, userListState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, UserListState state) {
    if (state.isLoading && state.users.isEmpty) {
      return const UserListLoading();
    }

    if (state.hasError && state.users.isEmpty) {
      return UserListError(
        message: state.errorMessage ?? 'Unknown error occurred',
        onRetry: () => ref.read(userListStateProvider.notifier).loadUsers(),
      );
    }

    if (state.users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No users found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(userListStateProvider.notifier).refreshUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.users.length,
        itemBuilder: (context, index) {
          final user = state.users[index];
          return UserCard(
            user: user,
            onTap: () => _navigateToUserDetail(context, user.id),
          );
        },
      ),
    );
  }

  void _navigateToUserDetail(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserDetailScreen(userId: userId)),
    );
  }
}
