import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String? phone;

  const UserEntity({required this.id, required this.name, required this.email, this.avatar, this.phone});

  @override
  List<Object?> get props => [id, name, email, avatar, phone];
}
