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

// Role Selection State
final class AuthRoleSelectionInProgress extends AuthState {}

final class AuthRoleSelectionSuccess extends AuthState {
}

final class AuthRoleSelectionFailure extends AuthState {
  final String message;

  AuthRoleSelectionFailure(this.message);
}
