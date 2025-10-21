import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_state_providers.dart';
import '../widgets/user_detail_content.dart';
import '../widgets/user_detail_loading.dart';
import '../widgets/user_detail_error.dart';

/// Screen displaying user details
class UserDetailScreen extends ConsumerWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(context, ref, userState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, UserState state) {
    if (state.isLoading) {
      return const UserDetailLoading();
    }

    if (state.hasError) {
      return UserDetailError(
        message: state.errorMessage ?? 'Unknown error occurred',
        onRetry: () => ref.read(userStateProvider(userId).notifier).loadUser(),
      );
    }

    if (state.user == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'User not found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return UserDetailContent(user: state.user!);
  }
}
