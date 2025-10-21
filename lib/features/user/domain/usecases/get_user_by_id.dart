import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting a user by ID
class GetUserById implements UseCase<User, int> {
  final UserRepository _repository;
  final Logger _logger = Logger('GetUserById');

  GetUserById({required UserRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, User>> call(int params) async {
    _logger.info('Executing GetUserById use case with ID: $params');
    return await _repository.getUserById(params);
  }
}
