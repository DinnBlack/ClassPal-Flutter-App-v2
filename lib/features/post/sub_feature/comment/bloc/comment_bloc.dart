import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/post/sub_feature/comment/model/comment_model.dart';
import 'package:classpal_flutter_app/features/post/sub_feature/comment/repository/comment_service.dart';
import 'package:meta/meta.dart';

part 'comment_event.dart';

part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentService commentService = CommentService();

  CommentBloc() : super(CommentInitial()) {
    on<CommentCreateStarted>(_onCommentCreateStarted);
    on<CommentFetchStarted>(_onCommentFetchStarted);
    on<CommentFetchLatestStarted>(_onCommentFetchLatestStarted);
    on<CommentUpdateStarted>(_onCommentUpdateStarted);
    on<CommentDeleteStarted>(_onCommentDeleteStarted);
  }

  // Insert a new comment
  Future<void> _onCommentCreateStarted(
      CommentCreateStarted event, Emitter<CommentState> emit) async {
    emit(CommentCreateInProgress());
    try {
      await commentService.insertComment(event.newsId, event.content);
      emit(CommentCreateSuccess());
      add(CommentFetchStarted(newsId: event.newsId));
    } catch (e) {
      emit(CommentCreateFailure(error: "Failed to create comment: ${e.toString()}"));
    }
  }

  // Fetch comments by news ID
  Future<void> _onCommentFetchStarted(
      CommentFetchStarted event, Emitter<CommentState> emit) async {
    emit(CommentFetchInProgress());
    try {
      List<CommentModel> comments = await commentService.getCommentsByNewsId(event.newsId);
      emit(CommentFetchSuccess(comments));
    } catch (e) {
      emit(CommentFetchFailure(error: "Failed to fetch comments: ${e.toString()}"));
    }
  }

  // Fetch latest comments
  Future<void> _onCommentFetchLatestStarted(
      CommentFetchLatestStarted event, Emitter<CommentState> emit) async {
    emit(CommentFetchLatestInProgress());
    try {
      List<CommentModel> comments = await commentService.getLatestComments(event.newsId);
      emit(CommentFetchLatestSuccess(comments));
    } catch (e) {
      emit(CommentFetchLatestFailure(error: "Failed to fetch latest comments: ${e.toString()}"));
    }
  }

  // Update a comment
  Future<void> _onCommentUpdateStarted(
      CommentUpdateStarted event, Emitter<CommentState> emit) async {
    emit(CommentUpdateInProgress());
    try {
      await commentService.updateComment(event.newsId, event.commentId, event.updatedContent);
      emit(CommentUpdateSuccess());
      add(CommentFetchStarted(newsId: event.newsId));
    } catch (e) {
      emit(CommentUpdateFailure(error: "Failed to update comment: ${e.toString()}"));
    }
  }

  // Delete a comment
  Future<void> _onCommentDeleteStarted(
      CommentDeleteStarted event, Emitter<CommentState> emit) async {
    emit(CommentDeleteInProgress());
    try {
      await commentService.deleteComment(event.newsId, event.commentId);
      emit(CommentDeleteSuccess());
      add(CommentFetchStarted(newsId: event.newsId));
    } catch (e) {
      emit(CommentDeleteFailure(error: "Failed to delete comment: ${e.toString()}"));
    }
  }
}