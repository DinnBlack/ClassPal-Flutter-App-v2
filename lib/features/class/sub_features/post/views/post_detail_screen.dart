import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../models/post_model.dart';
import 'widgets/custom_comment_item.dart';
import 'widgets/custom_post_list_item.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  final bool? isFocusTextField;

  const PostDetailScreen(
      {super.key, required this.post, this.isFocusTextField = false});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd \'thg\' MM, yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPostListItem(post: widget.post, disableOnTap: true,),
            Container(
              height: kMarginMd,
              color: kGreyLightColor,
            ),
            const SizedBox(
              height: kMarginMd,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.post.comments.length,
                itemBuilder: (context, index) {
                  final comment = widget.post.comments[index];
                  return CustomCommentItem(comment: comment);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
              ),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    controller: _commentController,
                    text: 'Thêm bình luận...',
                    onChanged: (text) {},
                    autofocus: widget.isFocusTextField ?? false,
                  ),
                ],
              ),
            ),
            const SizedBox(width: kMarginLg),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.paperPlane,
                size: 24,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: kMarginLg),
          ],
        ),
      ),
    );
  }
  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Bài đăng của ${widget.post.creatorName}',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
