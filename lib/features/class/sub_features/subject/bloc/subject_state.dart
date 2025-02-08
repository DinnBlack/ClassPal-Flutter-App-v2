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

// Subject create
class SubjectCreateInProgress extends SubjectState {}

class SubjectCreateSuccess extends SubjectState {}

class SubjectCreateFailure extends SubjectState {
  final String error;

  SubjectCreateFailure( this.error);
}