import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:flutter/foundation.dart';
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
    on<PostDeleteStarted>(_onPostDeleteStarted);
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
      List<PostModel> posts;
      final currentRoles = await AuthService().getCurrentRoles();
      if (currentRoles.contains('Parent') || currentRoles.contains('Student')) {
        posts = await postService.getMultiGroupNews();
      } else {
        posts = await postService.getGroupNews();
      }
      emit(PostFetchSuccess(posts));
    } catch (e) {
      emit(PostFetchFailure("Failed to fetch posts: ${e.toString()}"));
    }
  }

  // Delete a post
  Future<void> _onPostDeleteStarted(
      PostDeleteStarted event, Emitter<PostState> emit) async {
    emit(PostDeleteInProgress());
    try {
      await postService.deleteNews(event.newsId);
      print("Post deleted successfully");
      emit(PostDeleteSuccess());
      add(PostFetchStarted());
    } catch (e) {
      emit(PostDeleteFailure("Failed to delete post: ${e.toString()}"));
    }
  }
}
