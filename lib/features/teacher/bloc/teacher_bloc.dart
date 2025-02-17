import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/teacher/repository/teacher_service.dart';
import 'package:meta/meta.dart';

import '../../profile/model/profile_model.dart';

part 'teacher_event.dart';

part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherService teacherService = TeacherService();

  TeacherBloc() : super(TeacherInitial()) {
    on<TeacherFetchStarted>(_onTeacherFetchStarted);
    on<TeacherCreateStarted>(_onTeacherCreateStarted);
    on<TeacherCreateBatchStarted>(_onTeacherCreateBatchStarted);
    on<TeacherDeleteStarted>(_onTeacherDeleteStarted);
  }

  // Fetch the list of teacher
  Future<void> _onTeacherFetchStarted(TeacherFetchStarted event,
      Emitter<TeacherState> emit) async {
    emit(TeacherFetchInProgress());
    try {
      final teachers = await teacherService.getAllTeacher();
      emit(TeacherFetchSuccess(teachers));
    } catch (e) {
      emit(TeacherFetchFailure("Failed to fetch teachers: ${e.toString()}"));
    }
  }

  // Teacher Create
  Future<void> _onTeacherCreateStarted(
      TeacherCreateStarted event, Emitter<TeacherState> emit) async {
    emit(TeacherCreateInProgress());
    try {
      await teacherService.insertTeacher(event.name);
      print("Teacher created successfully");
      emit(TeacherCreateSuccess());
      add(TeacherFetchStarted());
    } catch (e) {
      print("Error creating teacher: $e");
      emit(TeacherCreateFailure(
          error: '"Failed to create teacher: ${e.toString()}"'));
    }
  }

  // Teacher Create Batch
  Future<void> _onTeacherCreateBatchStarted(
      TeacherCreateBatchStarted event, Emitter<TeacherState> emit) async {
    emit(TeacherCreateBatchInProgress());
    try {
      await teacherService.insertBatchTeacher(event.names);
      print("Teachers created successfully");
      emit(TeacherCreateBatchSuccess());
      add(TeacherFetchStarted());
    } catch (e) {
      print("Error creating teachers: $e");
      emit(TeacherCreateBatchFailure(
          error: '"Failed to create teachers: ${e.toString()}"'));
    }
  }

  // Teacher Delete
  Future<void> _onTeacherDeleteStarted(TeacherDeleteStarted event,
      Emitter<TeacherState> emit) async {
    emit(TeacherDeleteInProgress());
    try {
      await teacherService.deleteTeacher(event.teacherId);
      print("Teacher deleted successfully");
      emit(TeacherDeleteSuccess());
      add(TeacherFetchStarted());
    } catch (e) {
      print("Error deleting teacher: $e");
      emit(TeacherDeleteFailure(
          error: '"Failed to delete teacher: ${e.toString()}"'));
    }
  }
}
