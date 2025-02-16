part of 'roll_call_bloc.dart';

@immutable
sealed class RollCallState {}

final class RollCallInitial extends RollCallState {}

// Roll call create
class RollCallCreateInProgress extends RollCallState {}

class RollCallCreateSuccess extends RollCallState {}

class RollCallCreateFailure extends RollCallState {
  final String error;

  RollCallCreateFailure({required this.error});
}

// Roll call fetch
class RollCallFetchByDateRangeInProgress extends RollCallState {}

class RollCallFetchByDateRangeSuccess extends RollCallState {
  final List<RollCallEntryModel> rollCallEntries;

  RollCallFetchByDateRangeSuccess({required this.rollCallEntries});
}

class RollCallFetchByDateRangeFailure extends RollCallState {
  final String error;

  RollCallFetchByDateRangeFailure({required this.error});
}

// Roll call fetch
class RollCallFetchByDateInProgress extends RollCallState {}

class RollCallFetchByDateSuccess extends RollCallState {
  final List<RollCallEntryModel> rollCallEntries;

  RollCallFetchByDateSuccess({required this.rollCallEntries});
}

class RollCallFetchByDateFailure extends RollCallState {
  final String error;

  RollCallFetchByDateFailure({required this.error});
}
