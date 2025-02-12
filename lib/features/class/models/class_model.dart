import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_with_students_model.dart';
import '../../profile/model/profile_model.dart';

class ClassModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String? schoolId;
  final String creatorId;
  final DateTime updatedAt;
  final DateTime createdAt;
  final List<ProfileModel>? students;
  final List<ProfileModel>? teachers;
  final List<GroupWithStudentsModel>? groupWithStudents;

//<editor-fold desc="Data Methods">
  const ClassModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.schoolId,
    required this.creatorId,
    required this.updatedAt,
    required this.createdAt,
    this.students,
    this.teachers,
    this.groupWithStudents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          schoolId == other.schoolId &&
          creatorId == other.creatorId &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt &&
          students == other.students &&
          teachers == other.teachers &&
          groupWithStudents == other.groupWithStudents);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      schoolId.hashCode ^
      creatorId.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode ^
      students.hashCode ^
      teachers.hashCode ^
      groupWithStudents.hashCode;

  @override
  String toString() {
    return 'ClassModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' avatarUrl: $avatarUrl,' +
        ' schoolId: $schoolId,' +
        ' creatorId: $creatorId,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        ' students: $students,' +
        ' teachers: $teachers,' +
        ' groupWithStudents: $groupWithStudents,' +
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
    List<ProfileModel>? students,
    List<ProfileModel>? teachers,
    List<GroupWithStudentsModel>? groupWithStudents,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      schoolId: schoolId ?? this.schoolId,
      creatorId: creatorId ?? this.creatorId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      students: students ?? this.students,
      teachers: teachers ?? this.teachers,
      groupWithStudents: groupWithStudents ?? this.groupWithStudents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'avatarUrl': this.avatarUrl,
      'schoolId': this.schoolId,
      'creatorId': this.creatorId,
      'updatedAt': this.updatedAt.toIso8601String(),
      'createdAt': this.createdAt.toIso8601String(),
      'students': this.students?.map((student) => student.toMap()).toList(),
      'teachers': this.teachers?.map((teacher) => teacher.toMap()).toList(),
      'groupWithStudents': this.groupWithStudents
          ?.map((group) => group.toMap())
          .toList(),
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      id: map['_id'] ?? map['id'] ?? '',
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      schoolId: map['schoolId'] as String?,
      creatorId: map['creatorId'] as String,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      students: map['students'] != null
          ? (map['students'] as List)
              .map((student) => ProfileModel.fromMap(student))
              .toList()
          : [],
      teachers: map['teachers'] != null
          ? (map['teachers'] as List)
              .map((teacher) => ProfileModel.fromMap(teacher))
              .toList()
          : [],
      groupWithStudents: map['groupWithStudents'] != null
          ? (map['groupWithStudents'] as List)
              .map((group) => GroupWithStudentsModel.fromMap(group))
              .toList()
          : [],
    );
  }

//</editor-fold>
}
