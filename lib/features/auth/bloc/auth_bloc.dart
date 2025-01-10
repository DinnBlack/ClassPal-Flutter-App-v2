import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/user_model.dart';
import '../repository/user_service.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService = UserService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginStarted>(_onAuthLoginStarted);
    on<AuthRegisterStarted>(_onAuthRegisterStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
  }

  // Xử lý sự kiện đăng nhập
  Future<void> _onAuthLoginStarted(
      AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress());
    try {
      final user =
          await userService.login(event.emailOrPhoneNumber, event.password);
      if (user != null) {
        emit(AuthLoginSuccess(user));
      } else {
        emit(AuthLoginFailure("Invalid credentials"));
      }
    } catch (error) {
      emit(AuthLoginFailure(error.toString()));
    }
  }

  // Xử lý sự kiện đăng ký
  Future<void> _onAuthRegisterStarted(
      AuthRegisterStarted event, Emitter<AuthState> emit) async {
    emit(AuthRegisterInProgress());
    try {
      final success = await userService.register(
        event.name,
        event.emailOrPhoneNumber,
        event.password,
      );
      if (success) {
        emit(AuthRegisterSuccess());
      } else {
        emit(AuthRegisterFailure("Email already exists"));
      }
    } catch (error) {
      emit(AuthRegisterFailure(error.toString()));
    }
  }

  // Xử lý sự kiện đăng xuất
  Future<void> _onAuthLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    emit(AuthLogoutInProgress());
    try {
      await userService.logout();
      emit(AuthLogoutSuccess());
    } catch (error) {
      emit(AuthLogoutFailure(error.toString()));
    }
  }

}
