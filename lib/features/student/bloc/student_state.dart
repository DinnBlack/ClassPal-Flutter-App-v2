part of 'student_bloc.dart';

@immutable
sealed class StudentState {}

final class StudentInitial extends StudentState {}

// Fetching the list of students for a logged-in user
class StudentFetchInProgress extends StudentState {

}

class StudentFetchSuccess extends StudentState {
  final List<ProfileModel> students;

  StudentFetchSuccess(this.students);
}

class StudentFetchFailure extends StudentState {
  final String error;

  StudentFetchFailure(this.error);
}

// Insert a new student to personal class
class StudentCreateInProgress extends StudentState {}

class StudentCreateSuccess extends StudentState {}

class StudentCreateFailure extends StudentState {
  final String error;

  StudentCreateFailure(this.error);
}

// delete a student
class StudentDeleteInProgress extends StudentState {}

class StudentDeleteSuccess extends StudentState {}

class StudentDeleteFailure extends StudentState {
  final String error;

  StudentDeleteFailure(this.error);
}

// Insert a new student to personal class
class StudentUpdateAvatarInProgress extends StudentState {}

class StudentUpdateAvatarSuccess extends StudentState {}

class StudentUpdateAvatarFailure extends StudentState {
  final String error;

  StudentUpdateAvatarFailure(this.error);
}
