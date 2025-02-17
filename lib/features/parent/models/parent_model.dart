class ParentInvitationModel {
  final String studentName;
  final String studentId;
  final String? parentId;
  final String? parentName;
  final String? invitationStatus;

//<editor-fold desc="Data Methods">
  const ParentInvitationModel({
    required this.studentName,
    required this.studentId,
    this.parentId,
    this.parentName,
    this.invitationStatus,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentInvitationModel &&
          runtimeType == other.runtimeType &&
          studentName == other.studentName &&
          studentId == other.studentId &&
          parentId == other.parentId &&
          parentName == other.parentName &&
          invitationStatus == other.invitationStatus);

  @override
  int get hashCode =>
      studentName.hashCode ^
      studentId.hashCode ^
      parentId.hashCode ^
      parentName.hashCode ^
      invitationStatus.hashCode;

  @override
  String toString() {
    return 'ParentInvitationModel{' +
        ' studentName: $studentName,' +
        ' studentId: $studentId,' +
        ' parentId: $parentId,' +
        ' parentName: $parentName,' +
        ' invitationStatus: $invitationStatus,' +
        '}';
  }

  ParentInvitationModel copyWith({
    String? studentName,
    String? studentId,
    String? parentId,
    String? parentName,
    String? invitationStatus,
  }) {
    return ParentInvitationModel(
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentName': this.studentName,
      'studentId': this.studentId,
      'parentId': this.parentId,
      'parentName': this.parentName,
      'invitationStatus': this.invitationStatus,
    };
  }

  factory ParentInvitationModel.fromMap(Map<String, dynamic> map) {
    return ParentInvitationModel(
      studentName: map['studentName'] as String,
      studentId: map['studentId'] as String,
      parentId: map['parentId'] as String,
      parentName: map['parentName'] as String,
      invitationStatus: map['invitationStatus'] as String,
    );
  }

//</editor-fold>
}