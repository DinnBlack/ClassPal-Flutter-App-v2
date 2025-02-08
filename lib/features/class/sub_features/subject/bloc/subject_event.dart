part of 'subject_bloc.dart';

@immutable
sealed class SubjectEvent {}

class SubjectFetchStarted extends SubjectEvent {}

class SubjectCreateStarted extends SubjectEvent {
  final String name;
  final List<String> gradeTypes;

  SubjectCreateStarted({required this.name, required this.gradeTypes});
}
