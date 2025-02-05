part of 'class_bloc.dart';

@immutable
sealed class ClassEvent {}

class ClassPersonalFetchStarted extends ClassEvent {}

class ClassPersonalCreateStarted extends ClassEvent {
  final String name;
  final String? avatarUrl;

  ClassPersonalCreateStarted(
      {required this.name,
      this.avatarUrl});
}
