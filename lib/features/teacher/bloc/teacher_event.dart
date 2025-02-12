part of 'teacher_bloc.dart';

@immutable
sealed class TeacherEvent {}

class TeacherCreateStarted extends TeacherEvent {
  final String name;

  TeacherCreateStarted({required this.name});
}

class TeacherFetchStarted extends TeacherEvent {}
