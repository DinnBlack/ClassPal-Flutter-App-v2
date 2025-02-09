class GradeModel {
  final String id;
  final String studentId;
  final String subjectId;
  final String gradeTypeId;
  final double value;
  final String? comment;
  final DateTime updatedAt;
  final DateTime createdAt;

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
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      studentId.hashCode ^
      subjectId.hashCode ^
      gradeTypeId.hashCode ^
      value.hashCode ^
      comment.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'GradeModel{' +
        ' id: $id,' +
        ' studentId: $studentId,' +
        ' subjectId: $subjectId,' +
        ' gradeTypeId: $gradeTypeId,' +
        ' value: $value,' +
        ' comment: $comment,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'studentId': this.studentId,
      'subjectId': this.subjectId,
      'gradeTypeId': this.gradeTypeId,
      'value': this.value,
      'comment': this.comment,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory GradeModel.fromMap(Map<String, dynamic> map) {
    return GradeModel(
      id: map['id'] as String,
      studentId: map['studentId'] as String,
      subjectId: map['subjectId'] as String,
      gradeTypeId: map['gradeTypeId'] as String,
      value: map['value'] as double,
      comment: map['comment'] as String,
      updatedAt: map['updatedAt'] as DateTime,
      createdAt: map['createdAt'] as DateTime,
    );
  }

//</editor-fold>
}