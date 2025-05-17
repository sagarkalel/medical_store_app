import 'package:hive/hive.dart';

import '../../core/constants/hive_constants.dart';
import '../models/user_model.dart';

class AuthProvider {
  final Box<UserModel> _userBox = Hive.box<UserModel>(HiveConstants.userBox);
  final Box _authBox = Hive.box(HiveConstants.authBox);

  Future<UserModel?> login(String username, String password) async {
    final users = _userBox.values.toList();

    final foundUser = users.firstWhere(
      (user) => user.username == username && user.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    // if (foundUser != null) return null;

    await _authBox.put(HiveConstants.currentUserKey, foundUser.id);
    await _authBox.put(HiveConstants.isLoggedInKey, true);
    return foundUser;
  }

  Future<void> logout() async {
    await _authBox.delete(HiveConstants.currentUserKey);
    await _authBox.put(HiveConstants.isLoggedInKey, false);
  }

  bool get isLoggedIn =>
      _authBox.get(HiveConstants.isLoggedInKey, defaultValue: false);

  UserModel? get currentUser {
    final currentUserId = _authBox.get(HiveConstants.currentUserKey);
    if (currentUserId != null) {
      return _userBox.get(currentUserId);
    }
    return null;
  }

  bool get isAdmin => currentUser?.isAdmin ?? false;
}
