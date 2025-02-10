import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../repository/post_service.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostService postService = PostService();

  PostBloc() : super(PostInitial()) {
    on<PostCreateStarted>(_onPostCreateStarted);
  }

  // Insert a new post
  Future<void> _onPostCreateStarted(
      PostCreateStarted event, Emitter<PostState> emit) async {
    emit(PostCreateInProgress());
    try {
      await postService.insertNews(event.imageFile,
        event.content,
         event.targetRoles);
      print("Post created successfully");
      emit(PostCreateSuccess());
    } catch (e) {
      emit(PostCreateFailure("Failed to create post: ${e.toString()}"));
    }
  }
}
