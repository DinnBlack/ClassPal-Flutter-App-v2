import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/invitation/repository/invitation_service.dart';
import 'package:meta/meta.dart';
import '../../auth/repository/auth_service.dart';
import '../../profile/repository/profile_service.dart';

part 'invitation_event.dart';

part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final InvitationService invitationService = InvitationService();

  InvitationBloc() : super(InvitationInitial()) {
    on<InvitationCreateForParentStarted>(_onInvitationCreateForParentStarted);
    on<InvitationCreateForTeacherStarted>(_onInvitationCreateForTeacherStarted);
    on<InvitationAcceptStarted>(_onInvitationAcceptStarted);
    on<InvitationRemoveStarted>(_onInvitationRemoveStarted);
    on<InvitationSubmitGroupCodeStarted>(_onInvitationSubmitGroupCodeStarted);
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
      await invitationService.sendInvitationMailForTeacherPersonalClass(
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
      final profile =
          await invitationService.acceptMailInvitation(event.invitationId);
      // Lưu hồ sơ hiện tại
      print(profile);
      await ProfileService().saveCurrentProfile(profile!);

      // Lấy thông tin người dùng hiện tại
      final user = await AuthService().getCurrentUser();
      print(user);

      // Cập nhật hồ sơ với tên của người dùng
      await ProfileService().updateProfile(
        profileId: profile.id,
        name: user!.name,
      );
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

  // submit group code
  Future<void> _onInvitationSubmitGroupCodeStarted(
      InvitationSubmitGroupCodeStarted event,
      Emitter<InvitationState> emit) async {
    try {
      emit(InvitationSubmitGroupCodeInProgress());
      await invitationService.submitGroupCode(event.groupCode);
      emit(InvitationSubmitGroupCodeSuccess());
    } on Exception catch (e) {
      emit(InvitationSubmitGroupCodeFailure(error: e.toString()));
    }
  }
}
