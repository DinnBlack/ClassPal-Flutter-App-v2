part of 'class_bloc.dart';

@immutable
sealed class ClassState {}

final class ClassInitial extends ClassState {}

// Fetching the list of classes for a logged-in user
class ClassPersonalFetchInProgress extends ClassState {}

class ClassPersonalFetchSuccess extends ClassState {
  final List<ProfileModel> profiles;
  final List<ClassModel> classes;

  ClassPersonalFetchSuccess(this.profiles, this.classes);
}

class ClassPersonalFetchFailure extends ClassState {
  final String error;

  ClassPersonalFetchFailure(this.error);
}

// Fetching the list of classes school
class ClassSchoolFetchInProgress extends ClassState {}

class ClassSchoolFetchSuccess extends ClassState {
  final List<ClassModel> classes;

  ClassSchoolFetchSuccess(this.classes);
}

class ClassSchoolFetchFailure extends ClassState {
  final String error;

  ClassSchoolFetchFailure(this.error);
}

// Create a new Personal Class
class ClassPersonalCreateInProgress extends ClassState {}

class ClassPersonalCreateSuccess extends ClassState {}

class ClassPersonalCreateFailure extends ClassState {
  final String error;

  ClassPersonalCreateFailure(this.error);
}

// Create a new school Class
class ClassSchoolCreateInProgress extends ClassState {}

class ClassSchoolCreateSuccess extends ClassState {
  final ClassModel currentClass;

  ClassSchoolCreateSuccess(this.currentClass);
}

class ClassSchoolCreateFailure extends ClassState {
  final String error;

  ClassSchoolCreateFailure(this.error);
}

// Update class
class ClassUpdateInProgress extends ClassState {}

class ClassUpdateSuccess extends ClassState {}

class ClassUpdateFailure extends ClassState {
  final String error;

  ClassUpdateFailure(this.error);
}

// delete class
class ClassDeleteInProgress extends ClassState {}

class ClassDeleteSuccess extends ClassState {}

class ClassDeleteFailure extends ClassState {
  final String error;

  ClassDeleteFailure(this.error);
}

// Create a new school Class
class ClassSchoolBindRelInProgress extends ClassState {}

class ClassSchoolBindRelSuccess extends ClassState {}

class ClassSchoolBindRelFailure extends ClassState {
  final String error;

  ClassSchoolBindRelFailure(this.error);
}

// delete class
class ClassSchoolUnBindRelInProgress extends ClassState {}

class ClassSchoolUnBindRelSuccess extends ClassState {}

class ClassSchoolUnBindRelFailure extends ClassState {
  final String error;

  ClassSchoolUnBindRelFailure(this.error);
}

// Class Create batch
class ClassCreateBatchInProgress extends ClassState {}

class ClassCreateBatchSuccess extends ClassState {}

class ClassCreateBatchFailure extends ClassState {
  final String error;

  ClassCreateBatchFailure(this.error);
}
