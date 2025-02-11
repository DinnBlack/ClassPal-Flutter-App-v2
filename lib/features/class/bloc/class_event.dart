part of 'class_bloc.dart';

@immutable
sealed class ClassEvent {}

class ClassPersonalFetchStarted extends ClassEvent {}

class ClassPersonalCreateStarted extends ClassEvent {
  final String name;
  final String? avatarUrl;

  ClassPersonalCreateStarted({required this.name, this.avatarUrl});
}

class ClassSchoolCreateStarted extends ClassEvent {
  final String name;
  final String? avatarUrl;

  ClassSchoolCreateStarted({required this.name, this.avatarUrl});
}

class ClassUpdateStarted extends ClassEvent {
  final String newName;

  ClassUpdateStarted({required this.newName});
}
