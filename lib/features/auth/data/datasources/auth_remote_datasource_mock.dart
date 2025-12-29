import '../../../../core/error/app_exception.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Mock implementation for demo/testing purposes
/// Use this when you don't have a backend API ready
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  // Mock users database
  static const List<Map<String, String>> _mockUsers = [
    {'email': 'admin@test.com', 'password': 'password', 'name': 'Admin User', 'id': '1'},
    {'email': 'demo@test.com', 'password': '123456', 'name': 'Demo User', 'id': '2'},
    {'email': 'test@example.com', 'password': 'test123', 'name': 'Test User', 'id': '3'},
  ];

  // Store registered users in memory (for demo)
  final List<Map<String, String>> _registeredUsers = [];

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check in mock users first
    var user = _mockUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    // If not found, check registered users
    if (user.isEmpty) {
      user = _registeredUsers.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );
    }

    if (user.isNotEmpty) {
      return AuthResponseModel(
        token: 'mock_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}',
        user: UserModel(
          id: user['id']!,
          name: user['name']!,
          email: user['email']!,
          avatar: user['avatar'],
          phone: user['phone'],
        ),
      );
    } else {
      throw ServerException('Invalid email or password', statusCode: 401);
    }
  }

  @override
  Future<AuthResponseModel> register(String name, String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already exists
    final existingInMock = _mockUsers.firstWhere((user) => user['email'] == email, orElse: () => {});

    final existingInRegistered = _registeredUsers.firstWhere((user) => user['email'] == email, orElse: () => {});

    if (existingInMock.isNotEmpty || existingInRegistered.isNotEmpty) {
      throw ServerException('Email already exists', statusCode: 422);
    }

    // Create new user
    final newId = (_mockUsers.length + _registeredUsers.length + 1).toString();
    final newUser = {'id': newId, 'name': name, 'email': email, 'password': password};

    _registeredUsers.add(newUser);

    return AuthResponseModel(
      token: 'mock_token_${newId}_${DateTime.now().millisecondsSinceEpoch}',
      user: UserModel(id: newId, name: name, email: email),
    );
  }

  @override
  Future<bool> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return a default user (in real app, this would use the token)
    return const UserModel(id: '1', name: 'Current User', email: 'user@test.com');
  }
}
