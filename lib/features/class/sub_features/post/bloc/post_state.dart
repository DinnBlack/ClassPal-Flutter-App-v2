part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

// Post create
class PostCreateInProgress extends PostState {}

class PostCreateSuccess extends PostState {}

class PostCreateFailure extends PostState {
  final String error;

  PostCreateFailure(this.error);
}

class PostFetchInProgress extends PostState {}

class PostFetchSuccess extends PostState {
  final List<PostModel> posts;

  PostFetchSuccess(this.posts);
}

class PostFetchFailure extends PostState {
  final String error;

  PostFetchFailure(this.error);
}
