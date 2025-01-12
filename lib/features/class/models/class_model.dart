import 'package:classpal_flutter_app/features/student/models/student_group_model.dart';

import '../../student/models/student_model.dart';
import '../../teacher/models/teacher_model.dart';
import '../sub_features/attendance/models/atttendance_model.dart';
import '../sub_features/schedule/models/schedule_model.dart';

class ClassModel {
  final String _id;
  final String name;
  final String avatarUrl;
  final String? schoolId;
  final String creatorId;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const ClassModel({
    required this.name,
    required this.avatarUrl,
    this.schoolId,
    required this.creatorId,
    required this.updatedAt,
    required this.createdAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          schoolId == other.schoolId &&
          creatorId == other.creatorId &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      _id.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      schoolId.hashCode ^
      creatorId.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'ClassModel{' +
        ' _id: $_id,' +
        ' name: $name,' +
        ' avatarUrl: $avatarUrl,' +
        ' schoolId: $schoolId,' +
        ' creatorId: $creatorId,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  ClassModel copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? schoolId,
    String? creatorId,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ClassModel(
      id: id ?? this._id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      schoolId: schoolId ?? this.schoolId,
      creatorId: creatorId ?? this.creatorId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'name': this.name,
      'avatarUrl': this.avatarUrl,
      'schoolId': this.schoolId,
      'creatorId': this.creatorId,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['_id'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      schoolId: map['schoolId'] as String,
      creatorId: map['creatorId'] as String,
      updatedAt: map['updatedAt'] as DateTime,
      createdAt: map['createdAt'] as DateTime,
    );
  }

//</editor-fold>
}

