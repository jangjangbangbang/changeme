import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/get_user_by_id.dart';
import 'user_providers.dart';

part 'user_state_providers.freezed.dart';

/// State for user list
@freezed
class UserListState with _$UserListState {
  const factory UserListState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _UserListState;
}

/// State for individual user
@freezed
class UserState with _$UserState {
  const factory UserState({
    User? user,
    @Default(false) bool isLoading,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _UserState;
}

/// Provider for user list state
final userListStateProvider =
    StateNotifierProvider<UserListNotifier, UserListState>((ref) {
      final getUsers = ref.watch(getUsersProvider);
      return UserListNotifier(getUsers);
    });

/// Provider for individual user state
final userStateProvider =
    StateNotifierProvider.family<UserNotifier, UserState, int>((ref, userId) {
      final getUserById = ref.watch(getUserByIdProvider);
      return UserNotifier(getUserById, userId);
    });

/// Notifier for user list
class UserListNotifier extends StateNotifier<UserListState> {
  final GetUsers _getUsers;
  final Logger _logger = Logger('UserListNotifier');

  UserListNotifier(this._getUsers) : super(const UserListState());

  /// Load all users
  Future<void> loadUsers() async {
    _logger.info('Loading users');
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );

    final result = await _getUsers();

    result.fold(
      (failure) {
        _logger.severe('Failed to load users: ${failure.userMessage}');
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: failure.userMessage,
        );
      },
      (users) {
        _logger.info('Successfully loaded ${users.length} users');
        state = state.copyWith(
          users: users,
          isLoading: false,
          hasError: false,
          errorMessage: null,
        );
      },
    );
  }

  /// Refresh users
  Future<void> refreshUsers() async {
    _logger.info('Refreshing users');
    await loadUsers();
  }
}

/// Notifier for individual user
class UserNotifier extends StateNotifier<UserState> {
  final GetUserById _getUserById;
  final int _userId;
  final Logger _logger = Logger('UserNotifier');

  UserNotifier(this._getUserById, this._userId) : super(const UserState()) {
    loadUser();
  }

  /// Load user by ID
  Future<void> loadUser() async {
    _logger.info('Loading user with ID: $_userId');
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );

    final result = await _getUserById(_userId);

    result.fold(
      (failure) {
        _logger.severe('Failed to load user: ${failure.userMessage}');
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: failure.userMessage,
        );
      },
      (user) {
        _logger.info('Successfully loaded user: ${user.name}');
        state = state.copyWith(
          user: user,
          isLoading: false,
          hasError: false,
          errorMessage: null,
        );
      },
    );
  }
}
