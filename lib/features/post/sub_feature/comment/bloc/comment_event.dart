part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

// Tạo bình luận
class CommentCreateStarted extends CommentEvent {
  final String newsId;
  final String content;

  CommentCreateStarted({required this.newsId, required this.content});
}

// Lấy danh sách bình luận theo newsId
class CommentFetchStarted extends CommentEvent {
  final String newsId;

  CommentFetchStarted({required this.newsId});
}

// Lấy danh sách bình luận mới nhất
class CommentFetchLatestStarted extends CommentEvent {
  final String newsId;

  CommentFetchLatestStarted({required this.newsId});
}

// Cập nhật bình luận
class CommentUpdateStarted extends CommentEvent {
  final String newsId;
  final String commentId;
  final String updatedContent;

  CommentUpdateStarted({
    required this.newsId,
    required this.commentId,
    required this.updatedContent,
  });
}

// Xóa bình luận
class CommentDeleteStarted extends CommentEvent {
  final String newsId;
  final String commentId;

  CommentDeleteStarted({required this.newsId, required this.commentId});
}
