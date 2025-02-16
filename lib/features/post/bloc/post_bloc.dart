import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/post_model.dart';
import '../repository/post_service.dart';

part 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService = PostService();

  PostBloc() : super(PostInitial()) {
    on<PostCreateStarted>(_onPostCreateStarted);
    on<PostFetchStarted>(_onPostFetchStarted);
  }

  // Insert a new post
  Future<void> _onPostCreateStarted(
      PostCreateStarted event, Emitter<PostState> emit) async {
    emit(PostCreateInProgress());
    try {
      await postService.insertNews(event.imageFile, event.content);
      print("Post created successfully");
      emit(PostCreateSuccess());
      add(PostFetchStarted());
    } catch (e) {
      emit(PostCreateFailure("Failed to create post: ${e.toString()}"));
    }
  }

  // Fetch a list of posts
  Future<void> _onPostFetchStarted(
      PostFetchStarted event, Emitter<PostState> emit) async {
    emit(PostFetchInProgress());
    try {
      List<PostModel> posts = await postService.getGroupNews();
      emit(PostFetchSuccess(posts));
    } catch (e) {
      emit(PostFetchFailure("Failed to fetch posts: ${e.toString()}"));
    }
  }
}
