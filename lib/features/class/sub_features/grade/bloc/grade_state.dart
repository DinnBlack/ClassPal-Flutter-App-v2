part of 'grade_bloc.dart';

@immutable
sealed class GradeState {}

final class GradeInitial extends GradeState {}

// Grade Create
class GradeCreateInProgress extends GradeState {}

class GradeCreateSuccess extends GradeState {}

class GradeCreateFailure extends GradeState {
  final String error;

  GradeCreateFailure(this.error);
}

// Fetch grade by student id
class GradeFetchByStudentIdInProgress extends GradeState {}

class GradeFetchByStudentIdSuccess extends GradeState {
  final List<GradeModel> grades;

  GradeFetchByStudentIdSuccess(this.grades);
}

class GradeFetchByStudentIdFailure extends GradeState {
  final String error;

  GradeFetchByStudentIdFailure(this.error);
}

// Fetch grade by subject id
class GradeFetchBySubjectIdInProgress extends GradeState {}

class GradeFetchBySubjectIdSuccess extends GradeState {
  final List<GradeModel> grades;

  GradeFetchBySubjectIdSuccess(this.grades);
}

class GradeFetchBySubjectIdFailure extends GradeState {
  final String error;

  GradeFetchBySubjectIdFailure(this.error);
}

