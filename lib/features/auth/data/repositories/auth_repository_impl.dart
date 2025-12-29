import '../../../../core/error/app_exception.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ApiResult<AuthResponse>> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      return Success(AuthResponse(token: response.token, user: response.user.toEntity()));
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<AuthResponse>> register(String name, String email, String password) async {
    try {
      final response = await remoteDataSource.register(name, email, password);
      return Success(AuthResponse(token: response.token, user: response.user.toEntity()));
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<bool>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return Success(result);
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }

  @override
  Future<ApiResult<UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Success(user.toEntity());
    } on ServerException catch (e) {
      return Failure(e.message, statusCode: e.statusCode);
    } catch (e) {
      return Failure('Unexpected error: $e');
    }
  }
}
