part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

class StudentFetchStarted extends StudentEvent {
}

class StudentCreateStarted extends StudentEvent {
  final String name;

  StudentCreateStarted({required this.name});
}
