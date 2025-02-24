part of 'parent_bloc.dart';

@immutable
sealed class ParentEvent {}

class ParentInvitationFetchStarted extends ParentEvent {}

class ParentDeleteStarted extends ParentEvent {
  final String parentId;

  ParentDeleteStarted(this.parentId);
}

// parent fetch children
class ParentFetchChildrenStarted extends ParentEvent {}
