class RollCallSessionModel {
  final String id;
  final String classId;
  final DateTime date;
  final String createdBy;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const RollCallSessionModel({
    required this.id,
    required this.classId,
    required this.date,
    required this.createdBy,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RollCallSessionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          classId == other.classId &&
          date == other.date &&
          createdBy == other.createdBy &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      classId.hashCode ^
      date.hashCode ^
      createdBy.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'RollCallSessionModel{' +
        ' id: $id,' +
        ' classId: $classId,' +
        ' date: $date,' +
        ' createdBy: $createdBy,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  RollCallSessionModel copyWith({
    String? id,
    String? classId,
    DateTime? date,
    String? createdBy,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return RollCallSessionModel(
      id: id ?? this.id,
      classId: classId ?? this.classId,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'classId': this.classId,
      'date': this.date,
      'createdBy': this.createdBy,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory RollCallSessionModel.fromMap(Map<String, dynamic> map) {
    return RollCallSessionModel(
      id: map['_id'] as String,
      classId: map['classId'] as String,
      date: DateTime.parse(map['date'] as String),
      createdBy: map['createdBy'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

//</editor-fold>
}