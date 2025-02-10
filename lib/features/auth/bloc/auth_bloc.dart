import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../models/role_model.dart';
import '../models/user_model.dart';
import '../repository/auth_service.dart';
import '../../profile/repository/profile_service.dart';
import '../views/login_screen.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  final ProfileService profileService = ProfileService();

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
          await authService.login(event.emailOrPhoneNumber, event.password);
      await authService.getRoles();
      if (user != null) {
        emit(AuthLoginSuccess(user));
        await profileService.getProfileByUserId();
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
      final errorMessage = await authService.register(
        event.name,
        event.email,
        event.phoneNumber,
        event.password,
      );
      if (errorMessage == null) {
        emit(AuthRegisterSuccess());
      } else {
        emit(AuthRegisterFailure(errorMessage));
      }
    } catch (error) {
      emit(AuthRegisterFailure(error.toString()));
    }
  }

  Future<void> _onAuthLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    emit(AuthLogoutInProgress());
    try {
      await authService.logout();
      emit(AuthLogoutSuccess());

      // Delay navigation to prevent assertion error
      Future.microtask(() {
        if (event.context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            event.context,
            LoginScreen.route,
                (route) => false,
          );
        }
      });
    } catch (error) {
      emit(AuthLogoutFailure(error.toString()));
    }
  }

  // Xử lý sự kiện quên mật khẩu
  Future<void> _onAuthForgotPasswordStarted(
      AuthForgotPasswordStarted event, Emitter<AuthState> emit) async {
    emit(AuthForgotPasswordInProgress());
    try {
      await authService.forgotPassword(event.email);
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
      print('${event.email}, ${event.password}, ${event.otp}');
      await authService.resetPassword(
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
      AuthGetRolesStarted event, Emitter<AuthState> emit) async {}
}
