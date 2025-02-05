import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/class_model.dart';
import '../repository/class_service.dart';

part 'class_event.dart';

part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService classService = ClassService();

  ClassBloc() : super(ClassInitial()) {
    on<ClassPersonalFetchStarted>(_onClassPersonalFetchStarted);
    on<ClassPersonalCreateStarted>(_onClassPersonalCreateStarted);
  }

  // Fetch the list of classes personal
  Future<void> _onClassPersonalFetchStarted(
      ClassPersonalFetchStarted event, Emitter<ClassState> emit) async {
    emit(ClassPersonalFetchInProgress());
    try {
      final classes = await classService.getAllPersonalClass();
      print(classes);
      emit(ClassPersonalFetchSuccess(classes));
    } catch (e) {
      emit(ClassPersonalFetchFailure(
          "Failed to fetch classes: ${e.toString()}"));
    }
  }

  Future<void> _onClassPersonalCreateStarted(
      ClassPersonalCreateStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassPersonalCreateInProgress());
      await classService.insertPersonalClass(
        event.name,
        event.avatarUrl,
      );
      emit(ClassPersonalCreateSuccess());
    } on Exception catch (e) {
      emit(ClassPersonalCreateFailure(e.toString()));
    }
  }
}
