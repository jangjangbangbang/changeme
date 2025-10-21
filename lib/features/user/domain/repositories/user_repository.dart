import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Abstract repository interface for user operations
abstract class UserRepository {
  /// Get all users
  Future<Either<Failure, List<User>>> getUsers();

  /// Get user by ID
  Future<Either<Failure, User>> getUserById(int id);

  /// Create a new user
  Future<Either<Failure, User>> createUser(User user);

  /// Update an existing user
  Future<Either<Failure, User>> updateUser(User user);

  /// Delete a user
  Future<Either<Failure, void>> deleteUser(int id);
}
