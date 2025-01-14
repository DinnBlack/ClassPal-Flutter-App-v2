import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/features/class/sub_features/post/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/widgets/custom_avatar.dart';

class CustomCommentItem extends StatefulWidget {
  final CommentModel comment;

  const CustomCommentItem({super.key, required this.comment});

  @override
  State<CustomCommentItem> createState() => _CustomCommentItemState();
}

class _CustomCommentItemState extends State<CustomCommentItem> {
  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd \'thg\' MM, yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomAvatar(imageUrl: widget.comment.commenterAvatar),
        const SizedBox(
          width: kMarginSm,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: kPaddingSm, horizontal: kPaddingMd),
              decoration:  BoxDecoration(
                color: kGreyLightColor.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.all(Radius.circular(kBorderRadiusMd)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.comment.commenterName,
                    style: AppTextStyle.semibold(kTextSizeSm),
                  ),
                  Text(
                    widget.comment.commentText,
                    style: AppTextStyle.regular(kTextSizeXs),
                    softWrap: true,
                  )
                ],
              ),
            ),
            Text(
              formatDate(widget.comment.commentedAt),
              style: AppTextStyle.regular(kTextSizeXxs, kGreyColor),
            ),
          ],
        ),

      ],
    );
  }
}
