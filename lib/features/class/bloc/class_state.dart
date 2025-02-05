part of 'class_bloc.dart';

@immutable
sealed class ClassState {}

final class ClassInitial extends ClassState {}

// Fetching the list of classes for a logged-in user
class ClassPersonalFetchInProgress extends ClassState {}

class ClassPersonalFetchSuccess extends ClassState {
  final List<ClassModel> classes;

  ClassPersonalFetchSuccess(this.classes);
}

class ClassPersonalFetchFailure extends ClassState {
  final String error;

  ClassPersonalFetchFailure(this.error);
}

// Create a new Personal Class
class ClassPersonalCreateInProgress extends ClassState {}

class ClassPersonalCreateSuccess extends ClassState {}

class ClassPersonalCreateFailure extends ClassState {
  final String error;

  ClassPersonalCreateFailure(this.error);
}
