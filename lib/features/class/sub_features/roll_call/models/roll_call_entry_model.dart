enum RollCallStatus { present, absent, late, excused }

class RollCallEntryModel {
  final String id;
  final String sessionId;
  final String profileId;
  final String classId;
  final RollCallStatus status;
  final String? remarks;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? studentName;

//<editor-fold desc="Data Methods">
  const RollCallEntryModel({
    required this.id,
    required this.sessionId,
    required this.profileId,
    required this.classId,
    required this.status,
    this.remarks,
    required this.updatedAt,
    required this.createdAt,
    required this.studentName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RollCallEntryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          sessionId == other.sessionId &&
          profileId == other.profileId &&
          classId == other.classId &&
          status == other.status &&
          remarks == other.remarks &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt &&
          studentName == other.studentName);

  @override
  int get hashCode =>
      id.hashCode ^
      sessionId.hashCode ^
      profileId.hashCode ^
      classId.hashCode ^
      status.hashCode ^
      remarks.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode ^
      studentName.hashCode;

  @override
  String toString() {
    return 'RollCallEntryModel{' +
        ' id: $id,' +
        ' sessionId: $sessionId,' +
        ' profileId: $profileId,' +
        ' classId: $classId,' +
        ' status: $status,' +
        ' remarks: $remarks,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        ' studentName: $createdAt,' +
        '}';
  }

  RollCallEntryModel copyWith({
    String? id,
    String? sessionId,
    String? profileId,
    String? classId,
    RollCallStatus? status,
    String? remarks,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? studentName,
  }) {
    return RollCallEntryModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      profileId: profileId ?? this.profileId,
      classId: classId ?? this.classId,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      studentName: studentName ?? this.studentName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'sessionId': this.sessionId,
      'profileId': this.profileId,
      'classId': this.classId,
      'status': this.status,
      'remarks': this.remarks,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
      'studentName': this.studentName,
    };
  }

  factory RollCallEntryModel.fromMap(Map<String, dynamic> map) {
    return RollCallEntryModel(
      id: map['_id'] as String,
      sessionId: map['sessionId'] as String,
      profileId: map['profileId'] as String,
      classId: map['classId'] as String,
      status: RollCallStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => RollCallStatus.absent,
      ),
      remarks: map['remarks'] as String?,
      updatedAt: DateTime.parse(map['updatedAt']),
      createdAt: DateTime.parse(map['createdAt']),
      studentName: map['studentName'] as String? ?? '',
    );
  }

//</editor-fold>
}
