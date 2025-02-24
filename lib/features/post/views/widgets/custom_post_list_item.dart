import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../../../core/widgets/custom_avatar.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';
import '../../bloc/post_bloc.dart';
import '../../models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../post_detail_screen.dart';

class CustomPostListItem extends StatefulWidget {
  final bool isParentView;
  final PostModel post;
  final bool disableOnTap;

  const CustomPostListItem({
    super.key,
    required this.post,
    this.disableOnTap = false,
    this.isParentView = false,
  });

  @override
  State<CustomPostListItem> createState() => _CustomPostListItemState();
}

class _CustomPostListItemState extends State<CustomPostListItem> {
  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Xóa bài viết',
        'Chỉnh sửa bài viết',
      ],
      [
        () {
          _showDeleteConfirmationDialog(context);
        },
        () {
          print('chinh sua');
        },
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: const Text("Bạn có chắc chắn muốn xóa bài viết này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                context.read<PostBloc>().add(PostDeleteStarted(widget.post.id));
                Navigator.pop(context); // Đóng hộp thoại
              },
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

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
        padding: widget.disableOnTap
            ? null
            : const EdgeInsets.symmetric(vertical: kPaddingMd),
        color: kWhiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Row(
                children: [
                  CustomAvatar(profile: widget.post.creator),
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
                  if (!widget.isParentView)
                    GestureDetector(
                      onTap: () {
                        _showFeatureDialog(context);
                      },
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
                padding: widget.disableOnTap
                    ? const EdgeInsets.only(bottom: 0)
                    : const EdgeInsets.only(bottom: kMarginMd),
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
            widget.disableOnTap || widget.isParentView
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
                    child: GestureDetector(
                      onTap: () {
                        CustomPageTransition.navigateTo(
                          context: context,
                          page: PostDetailScreen(
                            post: widget.post,
                            isFocusTextField: true,
                          ),
                          transitionType: PageTransitionType.slideFromRight,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.solidCommentDots,
                              color: kPrimaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Bình luận',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
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
