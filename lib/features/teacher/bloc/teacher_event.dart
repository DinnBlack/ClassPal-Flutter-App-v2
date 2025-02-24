part of 'teacher_bloc.dart';

@immutable
sealed class TeacherEvent {}

// Teacher Create
class TeacherCreateStarted extends TeacherEvent {
  final String name;
  final String email;

  TeacherCreateStarted({required this.name, required this.email});
}

// Teacher Fetch
class TeacherFetchStarted extends TeacherEvent {}

// Teacher create batch
class TeacherCreateBatchStarted extends TeacherEvent {
  final List<Map<String, String>> teachers;

  TeacherCreateBatchStarted({required this.teachers});
}

// Teacher delete
class TeacherDeleteStarted extends TeacherEvent {
  final String teacherId;

  TeacherDeleteStarted({required this.teacherId});
}
