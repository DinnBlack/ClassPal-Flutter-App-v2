part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// Login State
final class AuthLoginInProgress extends AuthState {}

final class AuthLoginSuccess extends AuthState {
  final UserModel user;

  AuthLoginSuccess(this.user);
}

final class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure(this.message);
}

// Register State
final class AuthRegisterInProgress extends AuthState {}

final class AuthRegisterSuccess extends AuthState {}

final class AuthRegisterFailure extends AuthState {
  final String message;

  AuthRegisterFailure(this.message);
}

// Logout State
final class AuthLogoutInProgress extends AuthState {}

final class AuthLogoutSuccess extends AuthState {}

final class AuthLogoutFailure extends AuthState {
  final String message;

  AuthLogoutFailure(this.message);
}

// Forgot Password State
final class AuthForgotPasswordInProgress extends AuthState {}

final class AuthForgotPasswordSuccess extends AuthState {}

final class AuthForgotPasswordFailure extends AuthState {
  final String message;

  AuthForgotPasswordFailure(this.message);
}

// Reset Password State
final class AuthResetPasswordInProgress extends AuthState {}

final class AuthResetPasswordSuccess extends AuthState {}

final class AuthResetPasswordFailure extends AuthState {
  final String message;

  AuthResetPasswordFailure(this.message);
}

// Get Roles State
final class AuthGetRolesInProgress extends AuthState {}

final class AuthGetRolesSuccess extends AuthState {
  final List<String> roles;

  AuthGetRolesSuccess(this.roles);
}

final class AuthGetRolesFailure extends AuthState {
  final String message;

  AuthGetRolesFailure(this.message);
}
