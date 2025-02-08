part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}

class GroupFetchStarted extends GroupEvent {}

class GroupCreateStarted extends GroupEvent {
  final String name;
  final List<String> studentIds;

  GroupCreateStarted({required this.name, required this.studentIds});
}

class GroupUpdateStarted extends GroupEvent {
  final GroupWithStudentsModel groupWithStudents;
  final String? name;
  final List<String>? studentIds;

  GroupUpdateStarted(this.groupWithStudents, {this.name, this.studentIds});
}

class GroupDeleteStarted extends GroupEvent {
  final String groupId;

  GroupDeleteStarted(this.groupId);
}