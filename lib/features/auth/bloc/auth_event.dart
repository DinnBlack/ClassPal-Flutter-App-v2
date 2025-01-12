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
  final String email;
  final String phoneNumber;
  final String password;

  AuthRegisterStarted({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}

class AuthLogoutStarted extends AuthEvent {
  final BuildContext context;

  AuthLogoutStarted({
    required this.context,
  });
}

class AuthForgotPasswordStarted extends AuthEvent {
  final String email;

  AuthForgotPasswordStarted({
    required this.email,
  });
}

class AuthResetPasswordStarted extends AuthEvent {
  final String email;
  final String password;
  final String otp;

  AuthResetPasswordStarted({
    required this.email,
    required this.password,
    required this.otp,
  });
}

class AuthGetRolesStarted extends AuthEvent {}
