import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/invitation/repository/invitation_service.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';

part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final InvitationService invitationService = InvitationService();

  InvitationBloc() : super(InvitationInitial()) {
    on<InvitationCreateStarted>(_onInvitationCreateStarted);
  }

  // invitation send mail
  Future<void> _onInvitationCreateStarted(
      InvitationCreateStarted event, Emitter<InvitationState> emit) async {
    try {
      emit(InvitationCreateInProgress());
      await invitationService.sendInvitationMails(
        event.role,
        event.studentName,
        event.email,
      );
      emit(InvitationCreateSuccess());
    } on Exception catch (e) {
      emit(InvitationCreateFailure(error: e.toString()));
    }
  }
}
