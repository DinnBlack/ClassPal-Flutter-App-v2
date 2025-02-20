part of 'invitation_bloc.dart';

@immutable
sealed class InvitationEvent {}

class InvitationCreateForParentStarted extends InvitationEvent {
  final String name;
  final String email;
  final String studentId;

  InvitationCreateForParentStarted({required this.name, required this.email, required this.studentId});
}

class InvitationCreateForTeacherStarted extends InvitationEvent {
  final String name;
  final String email;

  InvitationCreateForTeacherStarted({required this.name, required this.email});
}

class InvitationAcceptStarted extends InvitationEvent {
  final String invitationId;

  InvitationAcceptStarted({required this.invitationId});
}

// Invitation remove
class InvitationRemoveStarted extends InvitationEvent {
  final String email;

  InvitationRemoveStarted({required this.email});
}
