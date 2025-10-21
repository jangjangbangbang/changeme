import 'package:dartz/dartz.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final Logger _logger = Logger('UserRepository');

  UserRepositoryImpl({
    required UserRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      _logger.info('Getting users from repository');

      if (await _networkInfo.isConnected) {
        final userModels = await _remoteDataSource.getUsers();
        final users = userModels.map((model) => model.toEntity()).toList();
        _logger.info('Successfully fetched ${users.length} users');
        return Right(users);
      } else {
        _logger.warning('No network connection available');
        return const Left(Failure.network(message: 'No internet connection'));
      }
    } catch (e) {
      _logger.severe('Error in getUsers: $e');
      final failure = ErrorHandler.handleException(e as Exception);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, User>> getUserById(int id) async {
    try {
      _logger.info('Getting user by ID: $id');

      if (await _networkInfo.isConnected) {
        final userModel = await _remoteDataSource.getUserById(id);
        final user = userModel.toEntity();
        _logger.info('Successfully fetched user: ${user.name}');
        return Right(user);
      } else {
        _logger.warning('No network connection available');
        return const Left(Failure.network(message: 'No internet connection'));
      }
    } catch (e) {
      _logger.severe('Error in getUserById: $e');
      final failure = ErrorHandler.handleException(e as Exception);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    try {
      _logger.info('Creating user: ${user.name}');

      if (await _networkInfo.isConnected) {
        // Convert entity to model for API call
        final userModel = UserModel(
          id: user.id,
          name: user.name,
          username: user.username,
          email: user.email,
          phone: user.phone,
          website: user.website,
          address: AddressModel(
            street: user.address.street,
            suite: user.address.suite,
            city: user.address.city,
            zipcode: user.address.zipcode,
            geo: GeoModel(lat: user.address.geo.lat, lng: user.address.geo.lng),
          ),
          company: CompanyModel(
            name: user.company.name,
            catchPhrase: user.company.catchPhrase,
            bs: user.company.bs,
          ),
        );

        final createdUserModel = await _remoteDataSource.createUser(userModel);
        final createdUser = createdUserModel.toEntity();
        _logger.info('Successfully created user: ${createdUser.name}');
        return Right(createdUser);
      } else {
        _logger.warning('No network connection available');
        return const Left(Failure.network(message: 'No internet connection'));
      }
    } catch (e) {
      _logger.severe('Error in createUser: $e');
      final failure = ErrorHandler.handleException(e as Exception);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      _logger.info('Updating user: ${user.name}');

      if (await _networkInfo.isConnected) {
        // Convert entity to model for API call
        final userModel = UserModel(
          id: user.id,
          name: user.name,
          username: user.username,
          email: user.email,
          phone: user.phone,
          website: user.website,
          address: AddressModel(
            street: user.address.street,
            suite: user.address.suite,
            city: user.address.city,
            zipcode: user.address.zipcode,
            geo: GeoModel(lat: user.address.geo.lat, lng: user.address.geo.lng),
          ),
          company: CompanyModel(
            name: user.company.name,
            catchPhrase: user.company.catchPhrase,
            bs: user.company.bs,
          ),
        );

        final updatedUserModel = await _remoteDataSource.updateUser(userModel);
        final updatedUser = updatedUserModel.toEntity();
        _logger.info('Successfully updated user: ${updatedUser.name}');
        return Right(updatedUser);
      } else {
        _logger.warning('No network connection available');
        return const Left(Failure.network(message: 'No internet connection'));
      }
    } catch (e) {
      _logger.severe('Error in updateUser: $e');
      final failure = ErrorHandler.handleException(e as Exception);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(int id) async {
    try {
      _logger.info('Deleting user with ID: $id');

      if (await _networkInfo.isConnected) {
        await _remoteDataSource.deleteUser(id);
        _logger.info('Successfully deleted user with ID: $id');
        return const Right(null);
      } else {
        _logger.warning('No network connection available');
        return const Left(Failure.network(message: 'No internet connection'));
      }
    } catch (e) {
      _logger.severe('Error in deleteUser: $e');
      final failure = ErrorHandler.handleException(e as Exception);
      return Left(failure);
    }
  }
}
