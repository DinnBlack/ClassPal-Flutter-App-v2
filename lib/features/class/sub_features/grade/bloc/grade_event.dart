part of 'grade_bloc.dart';

@immutable
sealed class GradeEvent {}

class GradeCreateInStarted extends GradeEvent {
  final String subjectId;
  final String studentId;
  final String gradeTypeId;
  final double value;
  final String comment;

  GradeCreateInStarted(
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
