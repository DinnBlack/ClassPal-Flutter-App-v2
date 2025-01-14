class CommentModel {
  final String _id;
  final String commenterName;
  final String commenterAvatar;
  final String commentText;
  final DateTime commentedAt;

//<editor-fold desc="Data Methods">
  const CommentModel({
    required this.commenterName,
    required this.commenterAvatar,
    required this.commentText,
    required this.commentedAt,
    required String id,
  }) : _id = id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommentModel &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          commenterName == other.commenterName &&
          commenterAvatar == other.commenterAvatar &&
          commentText == other.commentText &&
          commentedAt == other.commentedAt);

  @override
  int get hashCode =>
      _id.hashCode ^
      commenterName.hashCode ^
      commenterAvatar.hashCode ^
      commentText.hashCode ^
      commentedAt.hashCode;

  @override
  String toString() {
    return 'CommentModel{' +
        ' _id: $_id,' +
        ' commenterName: $commenterName,' +
        ' commenterAvatar: $commenterAvatar,' +
        ' commentText: $commentText,' +
        ' commentedAt: $commentedAt,' +
        '}';
  }

  CommentModel copyWith({
    String? id,
    String? commenterName,
    String? commenterAvatar,
    String? commentText,
    DateTime? commentedAt,
  }) {
    return CommentModel(
      id: id ?? this._id,
      commenterName: commenterName ?? this.commenterName,
      commenterAvatar: commenterAvatar ?? this.commenterAvatar,
      commentText: commentText ?? this.commentText,
      commentedAt: commentedAt ?? this.commentedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': this._id,
      'commenterName': this.commenterName,
      'commenterAvatar': this.commenterAvatar,
      'commentText': this.commentText,
      'commentedAt': this.commentedAt,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['_id'] as String,
      commenterName: map['commenterName'] as String,
      commenterAvatar: map['commenterAvatar'] as String,
      commentText: map['commentText'] as String,
      commentedAt: map['commentedAt'] as DateTime,
    );
  }

//</editor-fold>
}