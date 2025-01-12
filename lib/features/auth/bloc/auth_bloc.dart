import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/user_model.dart';
import '../repository/user_service.dart';
import '../views/login_screen.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService userService = UserService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginStarted>(_onAuthLoginStarted);
    on<AuthRegisterStarted>(_onAuthRegisterStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
    on<AuthForgotPasswordStarted>(_onAuthForgotPasswordStarted);
    on<AuthResetPasswordStarted>(_onAuthResetPasswordStarted);
    on<AuthGetRolesStarted>(_onAuthGetRolesStarted);
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
        event.email,
        event.phoneNumber,
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
      Navigator.pushNamedAndRemoveUntil(
        event.context,
        LoginScreen.route,
            (route) => false,
      );
    } catch (error) {
      emit(AuthLogoutFailure(error.toString()));
    }
  }

  // Xử lý sự kiện quên mật khẩu
  Future<void> _onAuthForgotPasswordStarted(
      AuthForgotPasswordStarted event, Emitter<AuthState> emit) async {
    emit(AuthForgotPasswordInProgress());
    try {
      // await Future.delayed(Duration(seconds: 2));
      await userService.forgotPassword(event.email);
      emit(AuthForgotPasswordSuccess());
    } catch (error) {
      emit(AuthForgotPasswordFailure(error.toString()));
    }
  }

  // Xử lý sự kiện đặt lại mật khẩu
  Future<void> _onAuthResetPasswordStarted(
      AuthResetPasswordStarted event, Emitter<AuthState> emit) async {
    emit(AuthResetPasswordInProgress());
    try {
      await userService.resetPassword(
        event.email,
        event.password,
        event.otp,
      );
      emit(AuthResetPasswordSuccess());
    } catch (error) {
      emit(AuthResetPasswordFailure(error.toString()));
    }
  }

  // Xử lý sự kiện lấy vai trò
  Future<void> _onAuthGetRolesStarted(
      AuthGetRolesStarted event, Emitter<AuthState> emit) async {
    emit(AuthGetRolesInProgress());
    try {
      final roles = await userService.getRoles();
      emit(AuthGetRolesSuccess(roles!));
    } catch (error) {
      emit(AuthGetRolesFailure(error.toString()));
    }
  }

}
