import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/get_users.dart';

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return UserRepositoryImpl(
    remoteDataSource: UserRemoteDataSourceImpl(apiClient: apiClient),
    networkInfo: networkInfo,
  );
});

/// Get users use case provider
final getUsersProvider = Provider<GetUsers>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUsers(repository: repository);
});

/// Get user by ID use case provider
final getUserByIdProvider = Provider<GetUserById>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserById(repository: repository);
});
