part of 'roll_call_bloc.dart';

@immutable
sealed class RollCallState {}

final class RollCallInitial extends RollCallState {}

class RollCallCreateInProgress extends RollCallState {}

class RollCallCreateSuccess extends RollCallState {}

class RollCallCreateFailure extends RollCallState {
  final String error;

  RollCallCreateFailure({required this.error});
}
