part of 'grade_bloc.dart';

@immutable
sealed class GradeEvent {}

class GradeCreateStarted extends GradeEvent {
  final String subjectId;
  final String studentId;
  final String gradeTypeId;
  final double value;
  final String comment;

  GradeCreateStarted(
      {required this.subjectId,
      required this.studentId,
      required this.gradeTypeId,
      required this.value,
      required this.comment});
}

// Grade fetch
class GradeFetchByStudentIdStarted extends GradeEvent {
  final String studentId;

  GradeFetchByStudentIdStarted(this.studentId);
}

// Grade fetch
class GradeFetchBySubjectIdStarted extends GradeEvent {
  final String subjectId;

  GradeFetchBySubjectIdStarted(this.subjectId);
}

// Grade update
class GradeUpdateStarted extends GradeEvent {
  final String subjectId;
  final String gradeId;
  final double value;
  final String comment;

  GradeUpdateStarted(
      {required this.subjectId,required this.gradeId, required this.value, required this.comment});
}

// Grade delete
class GradeDeleteStarted extends GradeEvent {
  final String subjectId;
  final String gradeId;

  GradeDeleteStarted(this.subjectId, this.gradeId);
}

