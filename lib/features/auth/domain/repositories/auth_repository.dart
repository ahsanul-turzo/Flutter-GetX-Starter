import '../../../../core/network/api_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<AuthResponse>> login(String email, String password);
  Future<ApiResult<AuthResponse>> register(String name, String email, String password);
  Future<ApiResult<bool>> logout();
  Future<ApiResult<UserEntity>> getCurrentUser();
}

class AuthResponse {
  final String token;
  final UserEntity user;

  AuthResponse({required this.token, required this.user});
}
