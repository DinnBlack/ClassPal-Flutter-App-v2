import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../auth/models/user_model.dart';
import '../models/class_model.dart';
import '../repository/class_service.dart';

part 'class_event.dart';
part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService classService = ClassService();

  ClassBloc() : super(ClassInitial()) {
    on<ClassFetchByUserStarted>(_onClassFetchByUserStarted);
    on<ClassFetchByIdStarted>(_onClassFetchByIdStarted);
  }

  // Fetch the list of classes for the logged-in user
  Future<void> _onClassFetchByUserStarted(
      ClassFetchByUserStarted event, Emitter<ClassState> emit) async {
    emit(ClassFetchByUserInProgress());
    try {
      final classes = await classService.fetchClassesByUser(event.user);
      emit(ClassFetchByUserSuccess(classes));
    } catch (e) {
      emit(ClassFetchByUserFailure("Failed to fetch classes: ${e.toString()}"));
    }
  }

  // Fetch a class by its ID
  Future<void> _onClassFetchByIdStarted(
      ClassFetchByIdStarted event, Emitter<ClassState> emit) async {
    emit(ClassFetchByIdInProgress());
    try {
      final currentClass = await classService.fetchClassById(event.classId);
      if (currentClass != null) {
        emit(ClassFetchByIdSuccess(currentClass));
      } else {
        emit(ClassFetchByIdFailure("Class not found"));
      }
    } catch (e) {
      emit(ClassFetchByIdFailure("Failed to fetch class: ${e.toString()}"));
    }
  }
}
