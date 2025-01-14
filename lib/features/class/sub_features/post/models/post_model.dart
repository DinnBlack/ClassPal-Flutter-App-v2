import 'comment_model.dart';

class PostModel {
  final String _id;
  final String creatorName;
  final String creatorAvatar;
  final String content;
  final List<String>? imageUrl;
  final DateTime createdAt;
  final int likes;
  final int views;
  final List<CommentModel> comments;

//<editor-fold desc="Data Methods">
  const PostModel({
    required this.creatorName,
    required this.creatorAvatar,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,
    required this.views,
    required this.comments,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          creatorName == other.creatorName &&
          creatorAvatar == other.creatorAvatar &&
          content == other.content &&
          imageUrl == other.imageUrl &&
          createdAt == other.createdAt &&
          likes == other.likes &&
          views == other.views &&
          comments == other.comments);

  @override
  int get hashCode =>
      _id.hashCode ^
      creatorName.hashCode ^
      creatorAvatar.hashCode ^
      content.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode ^
      likes.hashCode ^
      views.hashCode ^
      comments.hashCode;

  @override
  String toString() {
    return 'PostModel{' +
        ' _id: $_id,' +
        ' creatorName: $creatorName,' +
        ' creatorAvatar: $creatorAvatar,' +
        ' content: $content,' +
        ' imageUrl: $imageUrl,' +
        ' createdAt: $createdAt,' +
        ' likes: $likes,' +
        ' views: $views,' +
        ' comments: $comments,' +
        '}';
  }

  PostModel copyWith({
    String? id,
    String? creatorName,
    String? creatorAvatar,
    String? content,
    List<String>? imageUrl,
    DateTime? createdAt,
    int? likes,
    int? views,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id ?? this._id,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatar: creatorAvatar ?? this.creatorAvatar,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'creatorName': this.creatorName,
      'creatorAvatar': this.creatorAvatar,
      'content': this.content,
      'imageUrl': this.imageUrl,
      'createdAt': this.createdAt,
      'likes': this.likes,
      'views': this.views,
      'comments': this.comments,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] as String,
      creatorName: map['creatorName'] as String,
      creatorAvatar: map['creatorAvatar'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as List<String>,
      createdAt: map['createdAt'] as DateTime,
      likes: map['likes'] as int,
      views: map['views'] as int,
      comments: map['comments'] as List<CommentModel>,
    );
  }

//</editor-fold>
}