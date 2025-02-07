import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:meta/meta.dart';

import '../../class/models/class_model.dart';
import '../models/student_model.dart';
import '../repository/student_service.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService studentService = StudentService();

  StudentBloc() : super(StudentInitial()) {
    on<StudentFetchStarted>(_onStudentFetchStarted);

    on<StudentCreateStarted>(_onStudentCreateStarted);
  }

  // Fetch the list of student
  Future<void> _onStudentFetchStarted(
      StudentFetchStarted event, Emitter<StudentState> emit) async {
    emit(StudentFetchInProgress());
    try {
      final students = await studentService.getAllStudentClass();
      emit(StudentFetchSuccess(students));
    } catch (e) {
      emit(StudentFetchFailure("Failed to fetch students: ${e.toString()}"));
    }
  }

  // Create a new student
  Future<void> _onStudentCreateStarted(
      StudentCreateStarted event, Emitter<StudentState> emit) async {
    emit(StudentCreateInProgress());
    try {
       await studentService.insertStudent(event.name);
      emit(StudentCreateSuccess());
    } catch (e) {
      emit(StudentCreateFailure("Failed to create student: ${e.toString()}"));
    }
  }
}
