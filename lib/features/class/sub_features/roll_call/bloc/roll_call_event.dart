part of 'roll_call_bloc.dart';

@immutable
sealed class RollCallEvent {}

class RollCallCreateStarted extends RollCallEvent {
  final String date;
  final List<Map<String, int>> studentsRollCall;

  RollCallCreateStarted({required this.date, required this.studentsRollCall});
}

// Roll call fetch by date range
class RollCallFetchByDateRangeStarted extends RollCallEvent {
  final String startDate;
  final String endDate;

  RollCallFetchByDateRangeStarted(
      {required this.startDate, required this.endDate});
}

// Roll call fetch by date
class RollCallFetchByDateStarted extends RollCallEvent {
  final String date;

  RollCallFetchByDateStarted({required this.date});
}

// Update roll call entry
class RollCallEntryUpdateStarted extends RollCallEvent {
  final String entryId;
  final String status;
  final String remarks;

  RollCallEntryUpdateStarted(
      {required this.entryId, required this.status, required this.remarks});
}
