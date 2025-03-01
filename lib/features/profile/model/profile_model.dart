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
  final String? tempId;

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
    this.tempId, // Thêm tempId với mặc định là null
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
              createdAt == other.createdAt &&
              tempId == other.tempId);

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
      createdAt.hashCode ^
      tempId.hashCode;

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
        ' tempId: $tempId,' +
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
    String? tempId,
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
      tempId: tempId ?? this.tempId, // Thêm tempId vào copyWith
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
      'updatedAt': this.updatedAt.toIso8601String(),
      'createdAt': this.createdAt.toIso8601String(),
      'tempId': this.tempId, // Thêm tempId vào toMap
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? map['_id'] ?? '', // Tránh null cho id
      displayName: map['displayName'] ?? '', // Tránh null cho displayName
      avatarUrl: map['avatarUrl'] ?? '', // Tránh null cho avatarUrl
      userId: map['userId'] as String?, // Không ép kiểu nếu null
      groupId: map['groupId'] ?? '', // Tránh null cho groupId
      groupType: map['groupType'] ?? 0, // Nếu null, mặc định là 0
      roles: (map['roles'] as List?)?.map((e) => e.toString()).toList() ?? [],
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      tempId: map['tempId'] as String?, // Thêm tempId vào fromMap, mặc định là null
    );
  }

//</editor-fold>
}
