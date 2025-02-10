import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/class/sub_features/post/bloc/post_bloc.dart';
import 'widgets/custom_post_list_item.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostBloc()..add(PostFetchStarted()),
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostFetchInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostFetchSuccess) {
            if (state.posts.isEmpty) {
              return const Center(child: Text("Không có bài viết nào."));
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return CustomPostListItem(post: state.posts[index]);
              },
              separatorBuilder: (context, index) {
                return Container(
                  height: 10,
                  color: kGreyLightColor,
                );
              },
            );
          } else if (state is PostFetchFailure) {
            return Center(child: Text("Lỗi: ${state.error}"));
          }
          return const Center(child: Text("Chưa có dữ liệu."));
        },
      ),
    );
  }
}
