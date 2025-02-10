import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/sub_features/post/views/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../../../core/widgets/custom_avatar.dart';
import '../../models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomPostListItem extends StatefulWidget {
  final PostModel post;
  final bool disableOnTap;

  const CustomPostListItem({
    super.key,
    required this.post,
    this.disableOnTap = false,
  });

  @override
  State<CustomPostListItem> createState() => _CustomPostListItemState();
}

class _CustomPostListItemState extends State<CustomPostListItem> {


  String formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 1) {
      return "Hôm qua";
    } else if (difference.inDays > 1) {
      final DateFormat formatter = DateFormat('dd \'thg\' MM, yyyy');
      return formatter.format(dateTime);
    } else {
      return timeago.format(dateTime, locale: 'vi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disableOnTap
          ? null
          : () {
              CustomPageTransition.navigateTo(
                  context: context,
                  page: PostDetailScreen(post: widget.post),
                  transitionType: PageTransitionType.slideFromRight);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kPaddingMd),
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Row(
                children: [
                  CustomAvatar(imageUrl: widget.post.creator.avatarUrl),
                  const SizedBox(width: kMarginMd),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.post.creator.displayName,
                        style: AppTextStyle.semibold(kTextSizeMd),
                      ),
                      Text(
                        formatDate(widget.post.createdAt),
                        style: AppTextStyle.regular(kTextSizeXs),
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(FontAwesomeIcons.ellipsis),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(kPaddingMd),
              child: Text(
                widget.post.content,
                style: AppTextStyle.medium(kTextSizeSm),
              ),
            ),
            if (widget.post.imageUrl != null &&
                widget.post.imageUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: kMarginMd),
                child: SizedBox(
                  height: 300,
                  child: GestureDetector(
                    onTap: () => _showImageGallery(context),
                    child: Image.network(
                      widget.post.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Row(
                children: [
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.heart,
                        color: kRedColor,
                      ),
                      const SizedBox(width: kMarginSm),
                      Text('5 lượt thích',
                          style: AppTextStyle.regular(kTextSizeXxs)),
                    ],
                  ),
                  const SizedBox(width: kMarginMd),
                  GestureDetector(
                    onTap: () {
                      CustomPageTransition.navigateTo(
                          context: context,
                          page: PostDetailScreen(
                            post: widget.post,
                            isFocusTextField: true,
                          ),
                          transitionType: PageTransitionType.slideFromRight);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.comment,
                          color: kGreyColor,
                        ),
                        const SizedBox(width: kMarginSm),
                        Text('5 bình luận',
                            style: AppTextStyle.regular(kTextSizeXxs)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(kPaddingSm),
                    decoration: BoxDecoration(
                      color: kGreenColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(kBorderRadiusLg),
                    ),
                    child: Text(
                      '5 lượt xem',
                      style: AppTextStyle.regular(kTextSizeXxs, kGreenColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: PhotoView(
                  imageProvider: NetworkImage(widget.post.imageUrl!),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered,
                ),
              ),
              Positioned(
                top: 60,
                left: 20,
                child: InkWell(
                  child: const Icon(
                    FontAwesomeIcons.xmark,
                    color: kWhiteColor,
                    size: 24,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
