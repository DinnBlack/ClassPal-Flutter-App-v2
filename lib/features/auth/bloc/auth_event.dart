part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  final String emailOrPhoneNumber;
  final String password;

  AuthLoginStarted({
    required this.emailOrPhoneNumber,
    required this.password,
  });
}

class AuthRegisterStarted extends AuthEvent {
  final String name;
  final String emailOrPhoneNumber;
  final String password;

  AuthRegisterStarted({
    required this.name,
    required this.emailOrPhoneNumber,
    required this.password,
  });
}

class AuthLogoutStarted extends AuthEvent {}

