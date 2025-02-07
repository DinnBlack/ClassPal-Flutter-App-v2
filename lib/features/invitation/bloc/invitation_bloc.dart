import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'invitation_event.dart';
part 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  InvitationBloc() : super(InvitationInitial()) {
    on<InvitationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
