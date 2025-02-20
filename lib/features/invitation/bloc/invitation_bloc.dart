import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/invitation/repository/invitation_service.dart';
import 'package:classpal_flutter_app/features/teacher/bloc/teacher_bloc.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';

part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final InvitationService invitationService = InvitationService();

  InvitationBloc() : super(InvitationInitial()) {
    on<InvitationCreateForParentStarted>(_onInvitationCreateForParentStarted);
    on<InvitationCreateForTeacherStarted>(_onInvitationCreateForTeacherStarted);
    on<InvitationAcceptStarted>(_onInvitationAcceptStarted);
    on<InvitationRemoveStarted>(_onInvitationRemoveStarted);
  }

  // invitation send mail
  Future<void> _onInvitationCreateForParentStarted(
      InvitationCreateForParentStarted event,
      Emitter<InvitationState> emit) async {
    try {
      emit(InvitationCreateForParentInProgress());
      await invitationService.sendInvitationMailForParent(
          event.name, event.email, event.studentId);
      emit(InvitationCreateForParentSuccess());
    } on Exception catch (e) {
      emit(InvitationCreateForParentFailure(error: e.toString()));
    }
  }

  // invitation send mail for teacher
  Future<void> _onInvitationCreateForTeacherStarted(
      InvitationCreateForTeacherStarted event,
      Emitter<InvitationState> emit) async {
    try {
      emit(InvitationCreateForTeacherInProgress());
      await invitationService.sendInvitationMailForTeacher(
        event.name,
        event.email,
      );
      emit(InvitationCreateForTeacherSuccess());
    } on Exception catch (e) {
      emit(InvitationCreateForTeacherFailure(error: e.toString()));
    }
  }

  // accept invitation
  Future<void> _onInvitationAcceptStarted(
      InvitationAcceptStarted event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationAcceptInProgress());
      await invitationService.acceptMailInvitation(event.invitationId);
      emit(InvitationAcceptSuccess());
    } on Exception catch (e) {
      emit(InvitationAcceptFailure(error: e.toString()));
    }
  }

  // remove invitation
  Future<void> _onInvitationRemoveStarted(
      InvitationRemoveStarted event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationRemoveInProgress());
      await invitationService.removeInvitation(event.email);
      emit(InvitationRemoveSuccess());
    } on Exception catch (e) {
      emit(InvitationRemoveFailure(error: e.toString()));
    }
  }
}
