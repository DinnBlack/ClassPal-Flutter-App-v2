class ProfileModel {
  final String id;
  final String displayName;
  final String avatarUrl;
  final String? userId;
  final String groupId;
  final int groupType;
  final List<String> roles;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const ProfileModel({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    this.userId,
    required this.groupId,
    required this.groupType,
    required this.roles,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
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
      id.hashCode ^
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
        ' id: $id,' +
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
    int? groupType,
    List<String>? roles,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
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
      'id': this.id,
      'displayName': this.displayName,
      'avatarUrl': this.avatarUrl,
      'userId': this.userId,  // Nullable, can be null
      'groupId': this.groupId,
      'groupType': this.groupType,
      'roles': this.roles,
      'updatedAt': this.updatedAt.toIso8601String(),  // Convert DateTime to string
      'createdAt': this.createdAt.toIso8601String(),  // Convert DateTime to string
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? map['_id'] ?? '',  // Sử dụng 'id' nếu có, nếu không thì dùng '_id'
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] as String,
      userId: map['userId'] != null ? map['userId'] as String : null,  // Ensure userId can be null
      groupId: map['groupId'] as String,
      groupType: map['groupType'] as int,
      roles: List<String>.from(map['roles'] as List),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

//</editor-fold>
}