part of 'subject_bloc.dart';

@immutable
sealed class SubjectState {}

final class SubjectInitial extends SubjectState {}

// Fetch list subjects
class SubjectFetchInProgress extends SubjectState {}

class SubjectFetchSuccess extends SubjectState {
  final List<SubjectModel> subjects;

  SubjectFetchSuccess(this.subjects);
}

class SubjectFetchFailure extends SubjectState {
  final String error;

  SubjectFetchFailure(this.error);
}

// Fetch  subject by id
class SubjectFetchByIdInProgress extends SubjectState {}

class SubjectFetchByIdSuccess extends SubjectState {
  final SubjectModel subject;

  SubjectFetchByIdSuccess(this.subject);
}

class SubjectFetchByIdFailure extends SubjectState {
  final String error;

  SubjectFetchByIdFailure(this.error);
}

// Subject create
class SubjectCreateInProgress extends SubjectState {}

class SubjectCreateSuccess extends SubjectState {}

class SubjectCreateFailure extends SubjectState {
  final String error;

  SubjectCreateFailure( this.error);
}

// Subject update
class SubjectUpdateInProgress extends SubjectState {}

class SubjectUpdateSuccess extends SubjectState {}

class SubjectUpdateFailure extends SubjectState {
  final String error;

  SubjectUpdateFailure(this.error);
}

// Subject delete
class SubjectDeleteInProgress extends SubjectState {}

class SubjectDeleteSuccess extends SubjectState {}

class SubjectDeleteFailure extends SubjectState {
  final String error;

  SubjectDeleteFailure(this.error);
}
