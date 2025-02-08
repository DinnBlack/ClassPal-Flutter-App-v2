import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_model.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_with_students_model.dart';
import 'package:meta/meta.dart';
import '../repository/group_service.dart';

part 'group_event.dart';

part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupService groupService = GroupService();

  GroupBloc() : super(GroupInitial()) {
    on<GroupCreateStarted>(_onGroupCreateStarted);
    on<GroupFetchStarted>(_onGroupFetchStarted);
    on<GroupUpdateStarted>(_onGroupUpdateStarted);
    on<GroupDeleteStarted>(_onGroupDeleteStarted);
  }

  // Fetch the list of group
  Future<void> _onGroupFetchStarted(
      GroupFetchStarted event, Emitter<GroupState> emit) async {
    emit(GroupFetchInProgress());
    try {
      final groups = await groupService.getAllGroup();
      emit(GroupFetchSuccess(groups));
    } catch (e) {
      emit(GroupFetchFailure("Failed to fetch students: ${e.toString()}"));
    }
  }

  // Insert a new group
  Future<void> _onGroupCreateStarted(
      GroupCreateStarted event, Emitter<GroupState> emit) async {
    emit(GroupCreateInProgress());
    try {
      await groupService.insertGroup(event.name, event.studentIds);
      print("Group created successfully");
      emit(GroupCreateSuccess());
      add(GroupFetchStarted());
    } catch (e) {
      print("Error creating group: $e");
      emit(GroupCreateFailure("Failed to create group: ${e.toString()}"));
    }
  }

  // Group update
  Future<void> _onGroupUpdateStarted(
      GroupUpdateStarted event, Emitter<GroupState> emit) async {
    emit(GroupUpdateInProgress());
    try {
      await groupService.updateGroup(
          event.groupWithStudents, event.name, event.studentIds);
      emit(GroupUpdateSuccess());
      add(GroupFetchStarted());
    } catch (e) {
      emit(GroupUpdateFailure("Failed to update group: ${e.toString()}"));
    }
  }

  // Group delete
  Future<void> _onGroupDeleteStarted(
      GroupDeleteStarted event, Emitter<GroupState> emit) async {
    emit(GroupDeleteInProgress());
    try {
      await groupService.deleteGroup(event.groupId);
      emit(GroupDeleteSuccess());
      add(GroupFetchStarted());
    } catch (e) {
      emit(GroupDeleteFailure("Failed to delete group: ${e.toString()}"));
    }
  }
}
