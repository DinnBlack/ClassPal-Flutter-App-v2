class InvitationModel {
  final String id;
  final String email;
  final String groupId;
  final int groupType;
  final String role;
  final String? schoolId;
  final String? profileId;
  final String senderId;
  final DateTime expiredAt;

//<editor-fold desc="Data Methods">
  const InvitationModel({
    required this.id,
    required this.email,
    required this.groupId,
    required this.groupType,
    required this.role,
    this.schoolId,
    this.profileId,
    required this.senderId,
    required this.expiredAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvitationModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          groupId == other.groupId &&
          groupType == other.groupType &&
          role == other.role &&
          schoolId == other.schoolId &&
          profileId == other.profileId &&
          senderId == other.senderId &&
          expiredAt == other.expiredAt);

  @override
  int get hashCode =>
      id.hashCode ^
      email.hashCode ^
      groupId.hashCode ^
      groupType.hashCode ^
      role.hashCode ^
      schoolId.hashCode ^
      profileId.hashCode ^
      senderId.hashCode ^
      expiredAt.hashCode;

  @override
  String toString() {
    return 'InvitationModel{' +
        ' id: $id,' +
        ' email: $email,' +
        ' groupId: $groupId,' +
        ' groupType: $groupType,' +
        ' role: $role,' +
        ' schoolId: $schoolId,' +
        ' profileId: $profileId,' +
        ' senderId: $senderId,' +
        ' expiredAt: $expiredAt,' +
        '}';
  }

  InvitationModel copyWith({
    String? id,
    String? email,
    String? groupId,
    int? groupType,
    String? role,
    String? schoolId,
    String? profileId,
    String? senderId,
    DateTime? expiredAt,
  }) {
    return InvitationModel(
      id: id ?? this.id,
      email: email ?? this.email,
      groupId: groupId ?? this.groupId,
      groupType: groupType ?? this.groupType,
      role: role ?? this.role,
      schoolId: schoolId ?? this.schoolId,
      profileId: profileId ?? this.profileId,
      senderId: senderId ?? this.senderId,
      expiredAt: expiredAt ?? this.expiredAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'email': this.email,
      'groupId': this.groupId,
      'groupType': this.groupType,
      'role': this.role,
      'schoolId': this.schoolId,
      'profileId': this.profileId,
      'senderId': this.senderId,
      'expiredAt': this.expiredAt,
    };
  }

  factory InvitationModel.fromMap(Map<String, dynamic> map) {
    return InvitationModel(
      id: map['_id'] as String,
      email: map['email'] as String,
      groupId: map['groupId'] as String,
      groupType: map['groupType'] as int,
      role: map['role'] as String,
      schoolId: map['schoolId'] as String,
      profileId: map['profileId'] as String,
      senderId: map['senderId'] as String,
      expiredAt: map['expiredAt'] as DateTime,
    );
  }

//</editor-fold>
}