import '../../../../core/error/app_exception.dart';
import '../../../../services/api_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(String name, String email, String password);
  Future<bool> logout();
  Future<UserModel> getCurrentUser();
}

class AuthResponseModel {
  final String token;
  final UserModel user;

  AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(token: json['token'] as String, user: UserModel.fromJson(json['user']));
  }
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    try {
      final response = await apiService.post('/auth/login', {'email': email, 'password': password});

      if (response.isOk && response.body != null) {
        return AuthResponseModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Login failed', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<AuthResponseModel> register(String name, String email, String password) async {
    try {
      final response = await apiService.post('/auth/register', {'name': name, 'email': email, 'password': password});

      if (response.isOk && response.body != null) {
        return AuthResponseModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Registration failed', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final response = await apiService.post('/auth/logout', {});
      return response.isOk;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Logout failed: $e', originalError: e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiService.get('/auth/user');

      if (response.isOk && response.body != null) {
        return UserModel.fromJson(response.body['data']);
      } else {
        throw ServerException(response.body?['message'] ?? 'Failed to get user', statusCode: response.statusCode);
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error: $e', originalError: e);
    }
  }
}
