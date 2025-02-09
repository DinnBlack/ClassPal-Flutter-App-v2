part of 'subject_bloc.dart';

@immutable
sealed class SubjectEvent {}

// Subjects fetch
class SubjectFetchStarted extends SubjectEvent {}

// Subject fetch
class SubjectFetchByIdStarted extends SubjectEvent {
  final String subjectId;

  SubjectFetchByIdStarted(this.subjectId);
}

// Subject create
class SubjectCreateStarted extends SubjectEvent {
  final String name;
  final List<String> gradeTypes;

  SubjectCreateStarted({required this.name, required this.gradeTypes});
}

class SubjectUpdateStarted extends SubjectEvent {
  final SubjectModel subject;
  final String? name;
  final List<String>? gradeTypes;

  SubjectUpdateStarted({required this.subject, this.name, this.gradeTypes});
}

// Subject delete
class SubjectDeleteStarted extends SubjectEvent {
  final String subjectId;

  SubjectDeleteStarted(this.subjectId);
}
