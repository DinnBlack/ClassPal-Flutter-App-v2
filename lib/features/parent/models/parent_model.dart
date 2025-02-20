class ParentInvitationModel {
  final String? email;
  final String studentName;
  final String studentId;
  final String? parentId;
  final String? parentName;
  final String? invitationStatus;

//<editor-fold desc="Data Methods">
  const ParentInvitationModel({
    this.email,
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
          email == other.email &&
          studentName == other.studentName &&
          studentId == other.studentId &&
          parentId == other.parentId &&
          parentName == other.parentName &&
          invitationStatus == other.invitationStatus);

  @override
  int get hashCode =>
      email.hashCode ^
      studentName.hashCode ^
      studentId.hashCode ^
      parentId.hashCode ^
      parentName.hashCode ^
      invitationStatus.hashCode;

  @override
  String toString() {
    return 'ParentInvitationModel{' +
        ' email: $email,' +
        ' studentName: $studentName,' +
        ' studentId: $studentId,' +
        ' parentId: $parentId,' +
        ' parentName: $parentName,' +
        ' invitationStatus: $invitationStatus,' +
        '}';
  }

  ParentInvitationModel copyWith({
    String? email,
    String? studentName,
    String? studentId,
    String? parentId,
    String? parentName,
    String? invitationStatus,
  }) {
    return ParentInvitationModel(
      email: email ?? this.email,
      studentName: studentName ?? this.studentName,
      studentId: studentId ?? this.studentId,
      parentId: parentId ?? this.parentId,
      parentName: parentName ?? this.parentName,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'studentName': this.studentName,
      'studentId': this.studentId,
      'parentId': this.parentId,
      'parentName': this.parentName,
      'invitationStatus': this.invitationStatus,
    };
  }

  factory ParentInvitationModel.fromMap(Map<String, dynamic> map) {
    return ParentInvitationModel(
      email: map['email'] as String,
      studentName: map['studentName'] as String,
      studentId: map['studentId'] as String,
      parentId: map['parentId'] as String,
      parentName: map['parentName'] as String,
      invitationStatus: map['invitationStatus'] as String,
    );
  }

//</editor-fold>
}