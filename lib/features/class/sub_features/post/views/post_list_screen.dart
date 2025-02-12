import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/features/class/sub_features/post/bloc/post_bloc.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import 'widgets/custom_post_list_item.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<PostBloc>().add(PostFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state is PostFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PostFetchSuccess) {
          if (state.posts.isEmpty) {
            return _buildEmptyPostView();
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return CustomPostListItem(post: state.posts[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
          );
        }

        if (state is PostFetchFailure) {
          return Center(child: Text("Lỗi: ${state.error}"));
        }

        return _buildEmptyPostView();
      },
    );
  }
}

Widget _buildEmptyPostView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_news.jpg',
            height: 200,
          ),
          const SizedBox(height: kMarginLg),
          Text(
            'Chưa có bài viết nào!',
            style: AppTextStyle.bold(kTextSizeLg),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kMarginSm),
          Text(
            'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
            style: AppTextStyle.medium(kTextSizeXs),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
