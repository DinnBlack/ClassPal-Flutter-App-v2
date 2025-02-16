part of 'invitation_bloc.dart';

@immutable
sealed class InvitationEvent {}

class InvitationCreateStarted extends InvitationEvent {
  final String role;
  final String profileId;
  final String email;

  InvitationCreateStarted(
      {required this.role, required this.profileId, required this.email});
}
