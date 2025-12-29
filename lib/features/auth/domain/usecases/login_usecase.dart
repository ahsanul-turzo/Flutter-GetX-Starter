import '../../../../core/network/api_result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<ApiResult<AuthResponse>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
