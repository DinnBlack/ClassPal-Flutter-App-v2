import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/post/sub_feature/comment/model/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/widgets/custom_feature_dialog.dart';

class CustomCommentItem extends StatefulWidget {
  final CommentModel comment;
  final String newsId;

  const CustomCommentItem(
      {super.key, required this.comment, required this.newsId});

  @override
  State<CustomCommentItem> createState() => _CustomCommentItemState();
}

class _CustomCommentItemState extends State<CustomCommentItem> {
  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd \'thg\' MM, yyyy');
    return formatter.format(dateTime);
  }

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Chỉnh sửa bình luận',
        'Xóa bình luận',
      ],
      [
        () {
          print('Chỉnh sửa bình luận');
        },
        () {
          print('Xóa bình luận');
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showFeatureDialog(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAvatar(imageUrl: widget.comment.creator.avatarUrl),
          const SizedBox(
            width: kMarginSm,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: kPaddingSm, horizontal: kPaddingMd),
                decoration: BoxDecoration(
                  color: kGreyLightColor.withOpacity(0.5),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(kBorderRadiusMd)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.comment.creator.displayName,
                      style: AppTextStyle.semibold(kTextSizeSm),
                    ),
                    Text(
                      widget.comment.content,
                      style: AppTextStyle.regular(kTextSizeXs),
                      softWrap: true,
                    )
                  ],
                ),
              ),
              Text(
                formatDate(widget.comment.updatedAt),
                style: AppTextStyle.regular(kTextSizeXxs, kGreyColor),
              ),
            ],
          ),
        ],
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
