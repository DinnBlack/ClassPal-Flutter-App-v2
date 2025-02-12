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
    } catch (e) {
      print("Error creating teacher: $e");
      emit(TeacherCreateFailure(
          error: '"Failed to create teacher: ${e.toString()}"'));
    }
  }
}
