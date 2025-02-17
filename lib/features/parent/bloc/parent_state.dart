part of 'parent_bloc.dart';

@immutable
sealed class ParentState {}

final class ParentInitial extends ParentState {}

// parent fetch
class ParentInvitationFetchInProgress extends ParentState {}

class ParentInvitationFetchSuccess extends ParentState {
  final List<ParentInvitationModel> disconnectedParents;
  final List<ParentInvitationModel> pendingParents;
  final List<ParentInvitationModel> connectedParents;

  ParentInvitationFetchSuccess( {required this.disconnectedParents, required this.pendingParents, required this.connectedParents});
}

class ParentInvitationFetchFailure extends ParentState {
  final String error;

  ParentInvitationFetchFailure({required this.error});
}

// parent delete
class ParentDeleteInProgress extends ParentState {}

class ParentDeleteSuccess extends ParentState {}

class ParentDeleteFailure extends ParentState {
  final String error;

  ParentDeleteFailure({required this.error});
}
