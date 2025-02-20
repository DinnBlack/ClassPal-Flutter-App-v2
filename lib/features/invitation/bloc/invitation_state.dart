part of 'invitation_bloc.dart';

@immutable
sealed class InvitationState {}

final class InvitationInitial extends InvitationState {}

// invitation mail for parent
class InvitationCreateForParentInProgress extends InvitationState {}

class InvitationCreateForParentSuccess extends InvitationState {}

class InvitationCreateForParentFailure extends InvitationState {
  final String error;

  InvitationCreateForParentFailure({required this.error});
}

// invitation mail for teacher
class InvitationCreateForTeacherInProgress extends InvitationState {}

class InvitationCreateForTeacherSuccess extends InvitationState {}

class InvitationCreateForTeacherFailure extends InvitationState {
  final String error;

  InvitationCreateForTeacherFailure({required this.error});
}

// accept mail invitation
class InvitationAcceptInProgress extends InvitationState {}

class InvitationAcceptSuccess extends InvitationState {}

class InvitationAcceptFailure extends InvitationState {
  final String error;

  InvitationAcceptFailure({required this.error});
}

// remove mail invitation
class InvitationRemoveInProgress extends InvitationState {}

class InvitationRemoveSuccess extends InvitationState {}

class InvitationRemoveFailure extends InvitationState {
  final String error;

  InvitationRemoveFailure({required this.error});
}
