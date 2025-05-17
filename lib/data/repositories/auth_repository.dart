import '../data_providers/auth_provider.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();

  Future<UserModel?> login(String username, String password) async {
    try {
      return await _authProvider.login(username, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authProvider.logout();
  }

  bool get isLoggedIn => _authProvider.isLoggedIn;
  UserModel? get currentUser => _authProvider.currentUser;
  bool get isAdmin => _authProvider.isAdmin;
}
