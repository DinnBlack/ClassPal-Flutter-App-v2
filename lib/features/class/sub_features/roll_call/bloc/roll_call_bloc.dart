import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../repository/roll_call_service.dart';

part 'roll_call_event.dart';

part 'roll_call_state.dart';

class RollCallBloc extends Bloc<RollCallEvent, RollCallState> {
  final RollCallService rollCallService = RollCallService();

  RollCallBloc() : super(RollCallInitial()) {
    on<RollCallCreateStarted>(_onRollCallCreateStarted);
  }

  // RollCall Create
  Future<void> _onRollCallCreateStarted(
      RollCallCreateStarted event, Emitter<RollCallState> emit) async {
    emit(RollCallCreateInProgress());
    try {
      await rollCallService.createRollCall(event.date, event.studentsRollCall);
      print("Subject created successfully");
      emit(RollCallCreateSuccess());
    } catch (e) {
      emit(RollCallCreateFailure(
          error: "Failed to create roll call: ${e.toString()}"));
    }
  }
}
