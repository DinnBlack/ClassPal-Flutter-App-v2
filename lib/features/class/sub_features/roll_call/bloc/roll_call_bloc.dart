import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/class/sub_features/roll_call/models/roll_call_entry_model.dart';
import 'package:meta/meta.dart';

import '../repository/roll_call_service.dart';

part 'roll_call_event.dart';

part 'roll_call_state.dart';

class RollCallBloc extends Bloc<RollCallEvent, RollCallState> {
  final RollCallService rollCallService = RollCallService();

  RollCallBloc() : super(RollCallInitial()) {
    on<RollCallCreateStarted>(_onRollCallCreateStarted);
    on<RollCallFetchByDateRangeStarted>(_onRollCallFetchByDateRangeStarted);
    on<RollCallFetchByDateStarted>(_onRollCallFetchByDateStarted);

  }

  // RollCall Create
  Future<void> _onRollCallCreateStarted(
      RollCallCreateStarted event, Emitter<RollCallState> emit) async {
    emit(RollCallCreateInProgress());
    try {
      final isSuccess = await rollCallService.createRollCall(
          event.date, event.studentsRollCall);

      if (isSuccess) {
        print("rollcall created successfully");
        emit(RollCallCreateSuccess());
      } else {
        emit(RollCallCreateFailure(
            error: "Failed to create roll call}"));
      }
    } catch (e) {
      emit(RollCallCreateFailure(
          error: "Failed to create roll call: ${e.toString()}"));
    }
  }

  // RollCall Fetch by Date Range
  Future<void> _onRollCallFetchByDateRangeStarted(
      RollCallFetchByDateRangeStarted event,
      Emitter<RollCallState> emit) async {
    emit(RollCallFetchByDateRangeInProgress());
    try {
      final List<RollCallEntryModel> rollCallEntries =
          await rollCallService.getRollCallEntriesBySessionIdsByDateRange(
              event.startDate, event.endDate);
      emit(RollCallFetchByDateRangeSuccess(rollCallEntries: rollCallEntries));
    } catch (e) {
      emit(RollCallFetchByDateRangeFailure(
          error: "Failed to fetch roll call by date range: ${e.toString()}"));
    }
  }

  // RollCall Fetch by Date
  Future<void> _onRollCallFetchByDateStarted(
      RollCallFetchByDateStarted event, Emitter<RollCallState> emit) async {
    emit(RollCallFetchByDateInProgress());
    try {
      final RollCallEntryModel? rollCallEntries =
          await rollCallService.getRollCallEntriesBySessionIdsByDate(event.date);
      emit(RollCallFetchByDateSuccess(rollCallEntries: rollCallEntries!));
    } catch (e) {
      emit(RollCallFetchByDateFailure(
          error: "Failed to fetch roll call by date: ${e.toString()}"));
    }
  }
}
