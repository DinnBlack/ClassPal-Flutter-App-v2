part of 'class_bloc.dart';

@immutable
sealed class ClassEvent {}

class ClassFetchByUserStarted extends ClassEvent {
  final UserModel user;

  ClassFetchByUserStarted({required this.user});
}

class ClassFetchByIdStarted extends ClassEvent {
  final String classId;

  ClassFetchByIdStarted({required this.classId});
}

