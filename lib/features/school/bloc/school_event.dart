part of 'school_bloc.dart';

@immutable
abstract class SchoolEvent {}

class SchoolFetchByUserStarted extends SchoolEvent {
  final UserModel user;

  SchoolFetchByUserStarted({required this.user});
}

class SchoolFetchByIdStarted extends SchoolEvent {
  final String schoolId;

  SchoolFetchByIdStarted({required this.schoolId});
}
