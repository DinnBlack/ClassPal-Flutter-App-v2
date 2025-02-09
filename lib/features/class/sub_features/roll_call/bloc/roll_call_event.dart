part of 'roll_call_bloc.dart';

@immutable
sealed class RollCallEvent {}

class RollCallCreateStarted extends RollCallEvent {
  final String date;
  final List<Map<String, int>> studentsRollCall;

  RollCallCreateStarted({required this.date, required this.studentsRollCall });
}
