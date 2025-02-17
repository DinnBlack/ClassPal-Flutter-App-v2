import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:meta/meta.dart';
import '../../profile/repository/profile_service.dart';
import '../repository/student_service.dart';

part 'student_event.dart';

part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService studentService = StudentService();
  final ProfileService profileService = ProfileService();

  StudentBloc() : super(StudentInitial()) {
    on<StudentFetchStarted>(_onStudentFetchStarted);
    on<StudentCreateStarted>(_onStudentCreateStarted);
    on<StudentDeleteStarted>(_onStudentDeleteStarted);
    on<StudentUpdateStarted>(_onStudentUpdateStarted);
  }

  // Fetch the list of student
  Future<void> _onStudentFetchStarted(
      StudentFetchStarted event, Emitter<StudentState> emit) async {
    emit(StudentFetchInProgress());
    try {
      final students = await studentService.getStudents();
      emit(StudentFetchSuccess(students!));
    } catch (e) {
      emit(StudentFetchFailure("Failed to fetch students: ${e.toString()}"));
    }
  }

  // In the Bloc method:
  Future<void> _onStudentCreateStarted(
      StudentCreateStarted event, Emitter<StudentState> emit) async {
    emit(StudentCreateInProgress());
    try {
      await studentService.insertStudent(event.name);
      print("Student created successfully");
      emit(StudentCreateSuccess());
      add(StudentFetchStarted());
    } catch (e) {
      print("Error creating student: $e");
      emit(StudentCreateFailure("Failed to create student: ${e.toString()}"));
    }
  }

  // Delete Student
  Future<void> _onStudentDeleteStarted(
      StudentDeleteStarted event, Emitter<StudentState> emit) async {
    emit(StudentDeleteInProgress());
    try {
      await studentService.deleteStudent(event.studentId);
      print("Student deleted successfully");
      emit(StudentDeleteSuccess());
      add(StudentFetchStarted());
    } catch (e) {
      print("Error deleting student: $e");
      emit(StudentDeleteFailure("Failed to delete student: ${e.toString()}"));
    }
  }

  // Update Student Avatar
  Future<void> _onStudentUpdateStarted(
      StudentUpdateStarted event, Emitter<StudentState> emit) async {
    emit(StudentUpdateInProgress());
    try {
      await studentService.updateStudent(event.studentId, event.name, event.imageFile);
      print("Student updated successfully");
      emit(StudentUpdateSuccess());
      add(StudentFetchStarted());
    } catch (e) {
      print("$e");
      emit(StudentUpdateFailure("Failed to update student: ${e.toString()}"));
    }
  }
}
