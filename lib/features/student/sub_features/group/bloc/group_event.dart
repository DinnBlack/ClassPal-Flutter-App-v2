part of 'group_bloc.dart';

@immutable
sealed class GroupEvent {}

class GroupFetchStarted extends GroupEvent {}

class GroupCreateStarted extends GroupEvent {
  final String name;
  final List<String> studentIds;

  GroupCreateStarted({required this.name, required this.studentIds});
}
