import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.name, required super.email, super.avatar, super.phone});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatar != null) 'avatar': avatar,
      if (phone != null) 'phone': phone,
    };
  }

  UserEntity toEntity() => UserEntity(id: id, name: name, email: email, avatar: avatar, phone: phone);
}
