import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_model.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_with_students_model.dart';
import 'package:meta/meta.dart';

import '../../../../profile/model/profile_model.dart';
import '../repository/group_service.dart';

part 'group_event.dart';

part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupService groupService = GroupService();

  GroupBloc() : super(GroupInitial()) {
    on<GroupCreateStarted>(_onGroupCreateStarted);
    on<GroupFetchStarted>(_onGroupFetchStarted);
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
}
