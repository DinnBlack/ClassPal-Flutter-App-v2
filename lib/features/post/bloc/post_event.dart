part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

// Post create
class PostCreateStarted extends PostEvent {
  final File? imageFile;
  final String content;
  final List<String> targetRoles;

  PostCreateStarted({
    required this.imageFile,
    required this.content,
    required this.targetRoles,
  });
}

// Post fetch
class PostFetchStarted extends PostEvent {}
