import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/features/post/sub_feature/comment/bloc/comment_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../model/comment_model.dart';
import 'widgets/custom_comment_item.dart';

class CommentListScreen extends StatefulWidget {
  final String newsId;

  const CommentListScreen({super.key, required this.newsId});

  @override
  State<CommentListScreen> createState() => _CommentListScreenState();
}

class _CommentListScreenState extends State<CommentListScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<CommentBloc>()
        .add(CommentFetchStarted(newsId: widget.newsId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentFetchInProgress) {
          return _buildSkeletonLoading();
        } else if (state is CommentFetchFailure) {
          return Center(
            child: Text(state.error, style: const TextStyle(color: Colors.red)),
          );
        } else if (state is CommentFetchSuccess) {
          return state.comments.isEmpty
              ? const SizedBox.shrink()
              : _buildCommentList(state.comments);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) => const CommentSkeletonItem(),
    );
  }

  Widget _buildCommentList(List<CommentModel> comments) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: kMarginMd,
      ),
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      itemCount: comments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomCommentItem(comment: comments[index], newsId: widget.newsId,);
      },
    );
  }
}

class CommentSkeletonItem extends StatelessWidget {
  const CommentSkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAvatarSkeleton(),
        const SizedBox(width: kMarginSm),
        Expanded(child: _buildContentSkeleton()),
      ],
    );
  }

  Widget _buildAvatarSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildContentSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 14,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: 60,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
