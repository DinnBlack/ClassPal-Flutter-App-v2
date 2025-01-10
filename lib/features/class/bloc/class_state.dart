part of 'class_bloc.dart';

@immutable
sealed class ClassState {}

final class ClassInitial extends ClassState {}

// Fetching the list of classes for a logged-in user
class ClassFetchByUserInProgress extends ClassState {}

class ClassFetchByUserSuccess extends ClassState {
  final List<ClassModel> classes;

  ClassFetchByUserSuccess(this.classes);
}

class ClassFetchByUserFailure extends ClassState {
  final String error;

  ClassFetchByUserFailure(this.error);
}

// Fetching a school by its ID
class ClassFetchByIdInProgress extends ClassState {}

class ClassFetchByIdSuccess extends ClassState {
  final ClassModel school;

  ClassFetchByIdSuccess(this.school);
}

class ClassFetchByIdFailure extends ClassState {
  final String error;

  ClassFetchByIdFailure(this.error);
}
