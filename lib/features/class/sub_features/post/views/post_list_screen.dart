import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';
import '../repository/post_data.dart';
import 'widgets/custom_post_list_item.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: samplePosts.length,
      itemBuilder: (context, index) {
        return CustomPostListItem(post: samplePosts[index]);
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 10,
          color: kGreyLightColor,
        );
      },
    );
  }
}
