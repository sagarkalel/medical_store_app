import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(authRepository)
      : _authRepository = authRepository,
        super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    if (_authRepository.isLoggedIn) {
      final user = _authRepository.currentUser;
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final user = await _authRepository.login(username, password);
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ));
      } else {
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Invalid credentials',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await _authRepository.logout();
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
