class GradeModel {
  final String id;
  final String studentId;
  final String subjectId;
  final String gradeTypeId;
  final double value;
  final String? comment;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? subjectName;
  final String? gradeTypeName;
  final String? studentName;

  //<editor-fold desc="Data Methods">
  const GradeModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.gradeTypeId,
    required this.value,
    this.comment,
    required this.updatedAt,
    required this.createdAt,
    this.subjectName,
    this.gradeTypeName,
    this.studentName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GradeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          studentId == other.studentId &&
          subjectId == other.subjectId &&
          gradeTypeId == other.gradeTypeId &&
          value == other.value &&
          comment == other.comment &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt &&
          subjectName == other.subjectName &&
          gradeTypeName == other.gradeTypeName &&
          studentName == other.studentName);

  @override
  int get hashCode =>
      id.hashCode ^
      studentId.hashCode ^
      subjectId.hashCode ^
      gradeTypeId.hashCode ^
      value.hashCode ^
      comment.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode ^
      subjectName.hashCode ^
      gradeTypeName.hashCode ^
      studentName.hashCode;

  @override
  String toString() {
    return 'GradeModel{'
        ' id: $id,'
        ' studentId: $studentId,'
        ' subjectId: $subjectId,'
        ' gradeTypeId: $gradeTypeId,'
        ' value: $value,'
        ' comment: $comment,'
        ' updatedAt: $updatedAt,'
        ' createdAt: $createdAt,'
        ' subjectName: $subjectName,'
        ' gradeTypeName: $gradeTypeName,'
        ' studentName: $studentName,'
        '}';
  }

  GradeModel copyWith({
    String? id,
    String? studentId,
    String? subjectId,
    String? gradeTypeId,
    double? value,
    String? comment,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? subjectName,
    String? gradeTypeName,
    String? studentName,
  }) {
    return GradeModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      subjectId: subjectId ?? this.subjectId,
      gradeTypeId: gradeTypeId ?? this.gradeTypeId,
      value: value ?? this.value,
      comment: comment ?? this.comment,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      subjectName: subjectName ?? this.subjectName,
      gradeTypeName: gradeTypeName ?? this.gradeTypeName,
      studentName: studentName ?? this.studentName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'subjectId': subjectId,
      'gradeTypeId': gradeTypeId,
      'value': value,
      'comment': comment,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'subjectName': subjectName,
      'gradeTypeName': gradeTypeName,
      'studentName': studentName,
    };
  }

  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['_id'] as String,
      studentId: map['studentId'] as String,
      subjectId: map['subjectId'] as String,
      gradeTypeId: map['gradeTypeId'] as String,
      value: (map['value'] as num).toDouble(),
      comment: map['comment'] != null ? map['comment'] as String : null,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      subjectName:
          map['subjectName'] != null ? map['subjectName'] as String : null,
      gradeTypeName:
          map['gradeTypeName'] != null ? map['gradeTypeName'] as String : null,
      studentName:
          map['studentName'] != null ? map['studentName'] as String : null,
    );
  }
//</editor-fold>
}
