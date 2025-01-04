import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginStarted>(_onAuthLoginStarted);
    on<AuthRegisterStarted>(_onAuthRegisterStarted);
    on<AuthLogoutStarted>(_onAuthLogoutStarted);
  }

  Future<void> _onAuthLoginStarted(
      AuthLoginStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoginInProgress());
    try {
      print(event.emailOrPhoneNumber);
      print(event.password);
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthLoginSuccess());
    } catch (error) {
      emit(AuthLoginFailure());
    }
  }

  Future<void> _onAuthRegisterStarted(
      AuthRegisterStarted event, Emitter<AuthState> emit) async {
    emit(AuthRegisterInProgress());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthRegisterSuccess());
    } catch (error) {
      emit(AuthRegisterFailure());
    }
  }

  Future<void> _onAuthLogoutStarted(
      AuthLogoutStarted event, Emitter<AuthState> emit) async {
    emit(AuthLogoutInProgress());
    try {
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthLogoutSuccess());
    } catch (error) {
      emit(AuthLogoutFailure());
    }
  }
}
