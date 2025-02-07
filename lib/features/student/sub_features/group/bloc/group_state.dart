part of 'group_bloc.dart';

@immutable
sealed class GroupState {}

final class GroupInitial extends GroupState {}

// Fetch list groups
class GroupFetchInProgress extends GroupState {}

class GroupFetchSuccess extends GroupState {
  final List<GroupWithStudentsModel> groupsWithStudents;

  GroupFetchSuccess(this.groupsWithStudents);
}

class GroupFetchFailure extends GroupState {
  final String errorMessage;

  GroupFetchFailure(this.errorMessage);
}


class GroupCreateInProgress extends GroupState {}

class GroupCreateSuccess extends GroupState {}

class GroupCreateFailure extends GroupState {
  final String error;

  GroupCreateFailure( this.error);
}
