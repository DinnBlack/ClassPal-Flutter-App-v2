part of 'student_bloc.dart';

@immutable
sealed class StudentEvent {}

class StudentFetchStarted extends StudentEvent {
}

class StudentCreateStarted extends StudentEvent {
  final String name;

  StudentCreateStarted({required this.name});
}

class StudentDeleteStarted extends StudentEvent {
  final String studentId;

  StudentDeleteStarted({required this.studentId});
}

class StudentUpdateAvatarStarted extends StudentEvent {
  final File imageFile;
  final ProfileModel profile;

  StudentUpdateAvatarStarted({required this.imageFile, required this.profile});
}
