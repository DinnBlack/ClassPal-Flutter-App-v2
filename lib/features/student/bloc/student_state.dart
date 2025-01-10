part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

// Fetching the list of schools for a logged-in user
class StudentFetchByClassInProgress extends StudentState {}

class StudentFetchByClassSuccess extends StudentState {
  final List<StudentModel> students;

  StudentFetchByClassSuccess(this.students);
}

class StudentFetchByClassFailure extends StudentState {
  final String error;

  StudentFetchByClassFailure(this.error);
}
