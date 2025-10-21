import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Abstract interface for user remote data source
abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel> getUserById(int id);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(int id);
}

/// Implementation of user remote data source
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;
  final Logger _logger = Logger('UserRemoteDataSource');

  UserRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      _logger.info('Fetching users from API');
      final response = await _apiClient.dio.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          'Failed to fetch users: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.severe('DioException in getUsers: ${e.message}');
      throw NetworkException('Failed to fetch users: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error in getUsers: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> getUserById(int id) async {
    try {
      _logger.info('Fetching user by ID: $id');
      final response = await _apiClient.dio.get('/users/$id');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          'Failed to fetch user: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.severe('DioException in getUserById: ${e.message}');
      throw NetworkException('Failed to fetch user: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error in getUserById: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      _logger.info('Creating user: ${user.name}');
      final response = await _apiClient.dio.post('/users', data: user.toJson());

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          'Failed to create user: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.severe('DioException in createUser: ${e.message}');
      throw NetworkException('Failed to create user: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error in createUser: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      _logger.info('Updating user: ${user.name}');
      final response = await _apiClient.dio.put(
        '/users/${user.id}',
        data: user.toJson(),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          'Failed to update user: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.severe('DioException in updateUser: ${e.message}');
      throw NetworkException('Failed to update user: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error in updateUser: $e');
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    try {
      _logger.info('Deleting user with ID: $id');
      final response = await _apiClient.dio.delete('/users/$id');

      if (response.statusCode != 200) {
        throw ServerException(
          'Failed to delete user: ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      _logger.severe('DioException in deleteUser: ${e.message}');
      throw NetworkException('Failed to delete user: ${e.message}');
    } catch (e) {
      _logger.severe('Unexpected error in deleteUser: $e');
      throw ServerException('Unexpected error: $e');
    }
  }
}
