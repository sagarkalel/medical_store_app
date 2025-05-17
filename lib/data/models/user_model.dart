import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String password;

  @HiveField(3)
  final bool isAdmin;

  UserModel({
    String? id,
    required this.username,
    required this.password,
    this.isAdmin = false,
  }) : id = id ?? const Uuid().v4();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      isAdmin: json['isAdmin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? password,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
