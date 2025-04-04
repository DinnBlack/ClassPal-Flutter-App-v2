part of 'school_bloc.dart';

@immutable
sealed class SchoolState {}

final class SchoolInitial extends SchoolState {}

// Fetching the list of schools
class SchoolFetchInProgress extends SchoolState {}

class SchoolFetchSuccess extends SchoolState {
  final List<ProfileModel> profiles;
  final List<SchoolModel> schools;

  SchoolFetchSuccess(this.profiles, this.schools);
}

class SchoolFetchFailure extends SchoolState {
  final String error;

  SchoolFetchFailure(this.error);
}

// Create a new School
class SchoolCreateInProgress extends SchoolState {}

class SchoolCreateSuccess extends SchoolState {}

class SchoolCreateFailure extends SchoolState {
  final String error;

  SchoolCreateFailure(this.error);
}

// Delete a School
class SchoolDeleteInProgress extends SchoolState {}

class SchoolDeleteSuccess extends SchoolState {}

class SchoolDeleteFailure extends SchoolState {
  final String error;

  SchoolDeleteFailure(this.error);
}
