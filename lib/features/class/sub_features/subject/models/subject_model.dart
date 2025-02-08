import '../../grade/models/grade_type_model.dart';

class SubjectModel {
  final String _id;
  final String classId;
  final String name;
  final String avatarUrl;
  final List<GradeTypeModel> gradeTypes;
  final String? description;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const SubjectModel({
    required this.classId,
    required this.name,
    required this.avatarUrl,
    required this.gradeTypes,
    this.description,
    required this.updatedAt,
    required this.createdAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubjectModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          classId == other.classId &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          gradeTypes == other.gradeTypes &&
          description == other.description &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      _id.hashCode ^
      classId.hashCode ^
      name.hashCode ^
      avatarUrl.hashCode ^
      gradeTypes.hashCode ^
      description.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'SubjectModel{' +
        ' _id: $_id,' +
        ' classId: $classId,' +
        ' name: $name,' +
        ' avatarUrl: $avatarUrl,' +
        ' gradeTypes: $gradeTypes,' +
        ' description: $description,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  SubjectModel copyWith({
    String? id,
    String? classId,
    String? name,
    String? avatarUrl,
    List<GradeTypeModel>? gradeTypes,
    String? description,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return SubjectModel(
      id: id ?? this._id,
      classId: classId ?? this.classId,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gradeTypes: gradeTypes ?? this.gradeTypes,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'classId': this.classId,
      'name': this.name,
      'avatarUrl': this.avatarUrl,
      'gradeTypes': this.gradeTypes,
      'description': this.description,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['_id'] as String,
      classId: map['classId'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
      gradeTypes: (map['gradeTypes'] as List<dynamic>)
          .map((grade) => GradeTypeModel.fromMap(grade as Map<String, dynamic>))
          .toList(),
      description: map['description'] as String?,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

//</editor-fold>
}