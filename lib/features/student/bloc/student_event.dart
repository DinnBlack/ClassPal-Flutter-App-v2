part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

class StudentFetchByClassStarted extends StudentEvent {
  final ClassModel currentClass;

 StudentFetchByClassStarted({required this.currentClass});
}
