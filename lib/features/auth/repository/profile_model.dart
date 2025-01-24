enum GroupType {
  school, classGroup,}

enum ProfileRole {
  executive,  teacher,  student,   parent,}

class ProfileModel {
  final String _id;
  final String displayName;
  final String avatarUrl;
  final String? userId;
  final String groupId;
  final GroupType groupType;
  final List<String> roles;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const ProfileModel({
    required this.displayName,
    required this.avatarUrl,
    this.userId,
    required this.groupId,
    required this.groupType,
    required this.roles,
    required this.updatedAt,
    required this.createdAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          displayName == other.displayName &&
          avatarUrl == other.avatarUrl &&
          userId == other.userId &&
          groupId == other.groupId &&
          groupType == other.groupType &&
          roles == other.roles &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      _id.hashCode ^
      displayName.hashCode ^
      avatarUrl.hashCode ^
      userId.hashCode ^
      groupId.hashCode ^
      groupType.hashCode ^
      roles.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'ProfileModel{' +
        ' _id: $_id,' +
        ' displayName: $displayName,' +
        ' avatarUrl: $avatarUrl,' +
        ' userId: $userId,' +
        ' groupId: $groupId,' +
        ' groupType: $groupType,' +
        ' roles: $roles,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  ProfileModel copyWith({
    String? id,
    String? displayName,
    String? avatarUrl,
    String? userId,
    String? groupId,
    GroupType? groupType,
    List<String>? roles,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this._id,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userId: userId ?? this.userId,
      groupId: groupId ?? this.groupId,
      groupType: groupType ?? this.groupType,
      roles: roles ?? this.roles,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'displayName': this.displayName,
      'avatarUrl': this.avatarUrl,
      'userId': this.userId,
      'groupId': this.groupId,
      'groupType': this.groupType,
      'roles': this.roles,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['_id'] as String,
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] as String,
      userId: map['userId'] as String,
      groupId: map['groupId'] as String,
      groupType: map['groupType'] as GroupType,
      roles: map['roles'] as List<String>,
      updatedAt: map['updatedAt'] as DateTime,
      createdAt: map['createdAt'] as DateTime,
    );
  }

//</editor-fold>
}