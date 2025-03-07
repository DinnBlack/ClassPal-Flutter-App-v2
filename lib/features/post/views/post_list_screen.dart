import 'package:classpal_flutter_app/features/post/views/widgets/custom_post_create_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../bloc/post_bloc.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'widgets/custom_post_list_item.dart';

class PostListScreen extends StatefulWidget {
  final bool isParentView;
  final bool isStudentView;
  final bool isTeacherView;

  const PostListScreen({
    super.key,
    this.isParentView = false,
    this.isStudentView = false,
    this.isTeacherView = false,
  });

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
          return SingleChildScrollView(
            child: Column(
              children: [
                if (!widget.isParentView &&
                    !widget.isStudentView &&
                    !widget.isTeacherView) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
                    child: PostCreateButton(),
                  ),
                  const SizedBox(
                    height: kMarginMd,
                  ),
                ],
                _buildSkeletonLoading(),
              ],
            ),
          );
        }
        if (state is PostFetchSuccess) {
          if (state.posts.isEmpty) {
            return Column(
              children: [
                if (!widget.isParentView &&
                    !widget.isStudentView &&
                    !widget.isTeacherView) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
                    child: PostCreateButton(),
                  ),
                  const SizedBox(
                    height: kMarginMd,
                  ),
                ],
                const SizedBox(
                  height: kMarginMd,
                ),
                if (widget.isStudentView) ...[
                  _buildEmptyPostView(),
                ],
                if (!widget.isStudentView) ...[
                  Flexible(child: _buildEmptyPostView()),
                ],
              ],
            );
          }
          if (widget.isStudentView) {
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                return CustomPostListItem(
                  post: state.posts[index],
                  isParentView: true,
                );
              },
              separatorBuilder: (context, index) => Container(
                height: 10,
                color: kGreyLightColor,
              ),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: (!widget.isParentView || !widget.isTeacherView)
                ? state.posts.length + 1
                : state.posts.length,
            itemBuilder: (context, index) {
              if ((!widget.isParentView || !widget.isTeacherView) && index == 0) {
                return Column(
                  children: [
                    if (!widget.isParentView &&
                        !widget.isTeacherView) ...const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
                        child: PostCreateButton(),
                      ),
                      SizedBox(
                        height: kMarginMd,
                      ),
                    ],
                  ],
                );
              }

              final postIndex = !widget.isParentView || !widget.isStudentView
                  ? index - 1
                  : index;

              return CustomPostListItem(
                post: state.posts[postIndex],
                isParentView: widget.isParentView,
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                height: 10,
                color: kGreyLightColor,
              );
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

Widget _buildSkeletonLoading() {
  return SkeletonLoader(
    builder: ListView.separated(
      itemCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kMarginMd,
          ),
          // Header (Avatar + Tên)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: Row(
              children: [
                // Avatar giả lập
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: kMarginMd),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên giả lập
                    Container(
                      width: 100,
                      height: 12,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 5),
                    // Thời gian giả lập
                    Container(
                      width: 80,
                      height: 10,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
                const Spacer(),
                // Icon menu giả lập
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          const SizedBox(height: kMarginMd),

          // Nội dung bài viết giả lập
          Padding(
            padding: const EdgeInsets.all(kPaddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 5),
                Container(
                  width: 150,
                  height: 12,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),

          // Hình ảnh bài viết giả lập
          Padding(
            padding: const EdgeInsets.only(bottom: kMarginMd),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
            ),
          ),

          // Footer (Like, Comment, View)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: Row(
              children: [
                Row(
                  children: [
                    // Icon Like giả lập
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(width: kMarginSm),
                    Container(
                      width: 50,
                      height: 10,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
                const SizedBox(width: kMarginMd),
                Row(
                  children: [
                    // Icon Comment giả lập
                    Container(
                      width: 16,
                      height: 16,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(width: kMarginSm),
                    Container(
                      width: 50,
                      height: 10,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
                const Spacer(),
                // View giả lập
                Container(
                  width: 60,
                  height: 10,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: kMarginMd,
          ),
        ],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    ),
  );
}
