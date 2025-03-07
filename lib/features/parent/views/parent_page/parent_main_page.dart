import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../post/bloc/post_bloc.dart';
import '../../../post/views/post_list_screen.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _reFetchPosts(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: const PostListScreen(isParentView: true),
          ),
        ),
      ),
    );
  }

  Future<void> _reFetchPosts(BuildContext context) async {
    context.read<PostBloc>().add(PostFetchStarted());
  }
}
