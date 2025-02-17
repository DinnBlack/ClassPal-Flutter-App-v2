part of 'teacher_bloc.dart';

@immutable
sealed class TeacherEvent {}

class TeacherCreateStarted extends TeacherEvent {
  final String name;

  TeacherCreateStarted({required this.name});
}

class TeacherFetchStarted extends TeacherEvent {}

class TeacherCreateBatchStarted extends TeacherEvent {
  final List<String> names;

  TeacherCreateBatchStarted({required this.names});
}

class TeacherDeleteStarted extends TeacherEvent {
  final String teacherId;

  TeacherDeleteStarted({required this.teacherId});
}
