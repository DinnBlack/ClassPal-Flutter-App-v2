import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/parent/models/parent_model.dart';
import 'package:classpal_flutter_app/features/parent/repository/parent_service.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:meta/meta.dart';

part 'parent_event.dart';

part 'parent_state.dart';

class ParentBloc extends Bloc<ParentEvent, ParentState> {
  final ParentService parentService = ParentService();

  ParentBloc() : super(ParentInitial()) {
    on<ParentInvitationFetchStarted>(_onParentInvitationFetchStarted);
    on<ParentDeleteStarted>(_onParentDeleteStarted);
    on<ParentFetchChildrenStarted>(_onParentFetchChildrenStarted);
  }

  // parent fetch
  Future<void> _onParentInvitationFetchStarted(
      ParentInvitationFetchStarted event, Emitter<ParentState> emit) async {
    try {
      emit(ParentInvitationFetchInProgress());
      // Fetch danh sách phụ huynh
      final parents = await parentService.getParents();

      // Phân loại danh sách
      final disconnectedParents = parents
          .where((parent) => parent.invitationStatus == 'disconnected')
          .toList();
      final pendingParents = parents
          .where((parent) => parent.invitationStatus == 'pending')
          .toList();
      final connectedParents = parents
          .where((parent) => parent.invitationStatus == 'connected')
          .toList();

      emit(ParentInvitationFetchSuccess(
        disconnectedParents: disconnectedParents,
        pendingParents: pendingParents,
        connectedParents: connectedParents,
      ));
    } on Exception catch (e) {
      emit(ParentInvitationFetchFailure(error: e.toString()));
    }
  }

  // parent delete
  Future<void> _onParentDeleteStarted(
      ParentDeleteStarted event, Emitter<ParentState> emit) async {
    try {
      emit(ParentDeleteInProgress());
      // delete phụ huynh
      await parentService.deleteParent(event.parentId);

      emit(ParentDeleteSuccess());
      add(ParentInvitationFetchStarted());
    } on Exception catch (e) {
      emit(ParentDeleteFailure(error: e.toString()));
    }
  }

  // parent fetch children
  Future<void> _onParentFetchChildrenStarted(
      ParentFetchChildrenStarted event, Emitter<ParentState> emit) async {
    try {
      emit(ParentFetchChildrenInProgress());
      // Fetch danh sách con của phụ huynh
      final children = await parentService.getChildren();

      emit(ParentFetchChildrenSuccess(children: children));
    } on Exception catch (e) {
      emit(ParentFetchChildrenFailure(error: e.toString()));
    }
  }
}
