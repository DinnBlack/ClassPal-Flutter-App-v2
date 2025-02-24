part of 'class_bloc.dart';

@immutable
sealed class ClassEvent {}

class ClassPersonalFetchStarted extends ClassEvent {}

class ClassSchoolFetchStarted extends ClassEvent {}

class ClassPersonalCreateStarted extends ClassEvent {
  final String name;
  final File? avatarUrl;

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

class ClassDeleteStarted extends ClassEvent {
  final String classId;

  ClassDeleteStarted({required this.classId});
}

class ClassSchoolBindRelStarted extends ClassEvent {
  final List<String> profileIds;

  ClassSchoolBindRelStarted({required this.profileIds});
}

class ClassSchoolUnBindRelStarted extends ClassEvent {
  final List<String> profileIds;

  ClassSchoolUnBindRelStarted({required this.profileIds});
}

class ClassCreateBatchStarted extends ClassEvent {
  final List<String> classes;

  ClassCreateBatchStarted({required this.classes});
}
