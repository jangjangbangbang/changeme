import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting all users
class GetUsers implements UseCaseNoParams<List<User>> {
  final UserRepository _repository;
  final Logger _logger = Logger('GetUsers');

  GetUsers({required UserRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<User>>> call() async {
    _logger.info('Executing GetUsers use case');
    return await _repository.getUsers();
  }
}
