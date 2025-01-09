part of 'school_bloc.dart';

@immutable
sealed class SchoolState {}

final class SchoolInitial extends SchoolState {}

// Fetching the list of schools for a logged-in user
class SchoolFetchByUserInProgress extends SchoolState {}

class SchoolFetchByUserSuccess extends SchoolState {
  final List<SchoolModel> schools;

  SchoolFetchByUserSuccess(this.schools);
}

class SchoolFetchByUserFailure extends SchoolState {
  final String error;

  SchoolFetchByUserFailure(this.error);
}

// Fetching a school by its ID
class SchoolFetchByIdInProgress extends SchoolState {}

class SchoolFetchByIdSuccess extends SchoolState {
  final SchoolModel school;

  SchoolFetchByIdSuccess(this.school);
}

class SchoolFetchByIdFailure extends SchoolState {
  final String error;

  SchoolFetchByIdFailure(this.error);
}
