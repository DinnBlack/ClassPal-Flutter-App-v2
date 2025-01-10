import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../class/models/class_model.dart';
import '../models/student_model.dart';
import '../repository/student_service.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService studentService = StudentService();

  StudentBloc() : super(StudentInitial()) {
    on<StudentFetchByClassStarted>(_onStudentFetchByClassStarted);
  }

  // Fetch the list of student
  Future<void> _onStudentFetchByClassStarted(
      StudentFetchByClassStarted event, Emitter<StudentState> emit) async {
    emit(StudentFetchByClassInProgress());
    try {
      final students = await studentService.fetchStudentsByClass(event.currentClass);
      emit(StudentFetchByClassSuccess(students));
    } catch (e) {
      emit(StudentFetchByClassFailure("Failed to fetch students: ${e.toString()}"));
    }
  }
}
