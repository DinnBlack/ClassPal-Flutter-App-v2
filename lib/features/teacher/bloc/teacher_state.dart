part of 'teacher_bloc.dart';

@immutable
sealed class TeacherState {}

final class TeacherInitial extends TeacherState {}

// Create a new teacher
class TeacherCreateInProgress extends TeacherState {}

class TeacherCreateSuccess extends TeacherState {}

class TeacherCreateFailure extends TeacherState {
  final String error;

  TeacherCreateFailure({required this.error});
}

// Fetching the list of students for a logged-in user
class TeacherFetchInProgress extends TeacherState {}

class TeacherFetchSuccess extends TeacherState {
  final List<ProfileModel> teachers;

  TeacherFetchSuccess(this.teachers);
}

class TeacherFetchFailure extends TeacherState {
  final String error;

  TeacherFetchFailure(this.error);
}