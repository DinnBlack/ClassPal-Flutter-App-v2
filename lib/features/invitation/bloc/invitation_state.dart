part of 'invitation_bloc.dart';

@immutable
sealed class InvitationState {}

final class InvitationInitial extends InvitationState {}

class InvitationCreateInProgress extends InvitationState {}

class InvitationCreateSuccess extends InvitationState {}

class InvitationCreateFailure extends InvitationState {
  final String error;

  InvitationCreateFailure({required this.error});
}
