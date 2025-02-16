
class CommentModel {
  final String id;
  final String newsId;
  final String content;
  final Creator creator;
  final DateTime updatedAt;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const CommentModel({
    required this.id,
    required this.newsId,
    required this.content,
    required this.creator,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          newsId == other.newsId &&
          content == other.content &&
          creator == other.creator &&
          updatedAt == other.updatedAt &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      newsId.hashCode ^
      content.hashCode ^
      creator.hashCode ^
      updatedAt.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'CommentModel{' +
        ' id: $id,' +
        ' newsId: $newsId,' +
        ' content: $content,' +
        ' creator: $creator,' +
        ' updatedAt: $updatedAt,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  CommentModel copyWith({
    String? id,
    String? newsId,
    String? content,
    Creator? creator,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return CommentModel(
      id: id ?? this.id,
      newsId: newsId ?? this.newsId,
      content: content ?? this.content,
      creator: creator ?? this.creator,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'newsId': this.newsId,
      'content': this.content,
      'creator': this.creator,
      'updatedAt': this.updatedAt,
      'createdAt': this.createdAt,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['_id'] as String? ?? '', // Fix key and handle null
      newsId: map['newsId'] as String? ?? '',
      content: map['content'] as String? ?? '',
      creator: Creator.fromMap(map['creator'] as Map<String, dynamic>? ?? {}), // Handle null
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(), // Handle invalid date
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

//</editor-fold>
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
}
