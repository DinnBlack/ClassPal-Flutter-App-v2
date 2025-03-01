class PostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final List<String> targetRoles;
  final Creator creator;
  final String groupId;
  final DateTime updatedAt;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.targetRoles,
    required this.creator,
    required this.groupId,
    required this.updatedAt,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String?,
      targetRoles: List<String>.from(map['targetRoles'] ?? []),
      creator: Creator.fromMap(map['creator'] as Map<String, dynamic>),
      groupId: map['groupId'] as String,
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'content': content,
      'imageUrl': imageUrl,
      'targetRoles': targetRoles,
      'creator': creator.toMap(),
      'groupId': groupId,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'PostModel(id: $id, content: $content, imageUrl: $imageUrl, targetRoles: $targetRoles, creator: $creator, groupId: $groupId, updatedAt: $updatedAt, createdAt: $createdAt)';
  }
}

class Creator {
  final String id;
  final String displayName;
  final String avatarUrl;

  const Creator({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
  });

  factory Creator.fromMap(Map<String, dynamic> map) {
    return Creator(
      id: map['_id'] as String,
      displayName: map['displayName'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'Creator(id: $id, displayName: $displayName, avatarUrl: $avatarUrl)';
  }
}
