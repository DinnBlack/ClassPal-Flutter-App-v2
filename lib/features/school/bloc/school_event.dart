part of 'school_bloc.dart';

@immutable
abstract class SchoolEvent {}

class SchoolFetchStarted extends SchoolEvent {}

class SchoolCreateStarted extends SchoolEvent {
  final String name;
  final String address;
  final String phoneNumber;
  final String? avatarUrl;

  SchoolCreateStarted(
      {required this.name,
      required this.address,
      required this.phoneNumber,
      this.avatarUrl});
}
