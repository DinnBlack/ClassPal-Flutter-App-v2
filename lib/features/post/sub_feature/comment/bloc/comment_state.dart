part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

// comment create
class CommentCreateInProgress extends CommentState {}

class CommentCreateSuccess extends CommentState {}

class CommentCreateFailure extends CommentState {
  final String error;

  CommentCreateFailure({required this.error});
}

// comment fetch by news id
class CommentFetchInProgress extends CommentState {}

class CommentFetchSuccess extends CommentState {
  final List<CommentModel> comments;

  CommentFetchSuccess(this.comments);
}

class CommentFetchFailure extends CommentState {
  final String error;

  CommentFetchFailure({required this.error});
}

// Lấy danh sách bình luận mới nhất
class CommentFetchLatestInProgress extends CommentState {}

class CommentFetchLatestSuccess extends CommentState {
  final List<CommentModel> comments;

  CommentFetchLatestSuccess(this.comments);
}

class CommentFetchLatestFailure extends CommentState {
  final String error;

  CommentFetchLatestFailure({required this.error});
}

// Cập nhật bình luận
class CommentUpdateInProgress extends CommentState {}

class CommentUpdateSuccess extends CommentState {}

class CommentUpdateFailure extends CommentState {
  final String error;

  CommentUpdateFailure({required this.error});
}

// Xóa bình luận
class CommentDeleteInProgress extends CommentState {}

class CommentDeleteSuccess extends CommentState {}

class CommentDeleteFailure extends CommentState {
  final String error;

  CommentDeleteFailure({required this.error});
}

