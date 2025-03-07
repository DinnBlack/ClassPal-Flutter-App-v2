import 'package:classpal_flutter_app/features/post/sub_feature/comment/views/comment_list_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../models/post_model.dart';
import '../sub_feature/comment/bloc/comment_bloc.dart';
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

  void _onSendComment() {
    if (_commentController.text.trim().isNotEmpty) {
      context.read<CommentBloc>().add(
            CommentCreateStarted(
              newsId: widget.post.id,
              content: _commentController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is CommentCreateSuccess) {
          _commentController.clear();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kIsWeb ? kTransparentColor: kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomSheet: _buildBottom(),
      ),
    );
  }

  Container _buildBottom() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? kPaddingLg : kPaddingMd),
      height: 70,
      color: kTransparentColor,
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
            onTap: _onSendComment,
            child: const Icon(
              FontAwesomeIcons.paperPlane,
              size: 24,
              color: kPrimaryColor,
            ),
          ),
          const SizedBox(width: kMarginLg),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomPostListItem(post: widget.post, disableOnTap: true),
          Container(height: kMarginMd, color: kGreyLightColor),
          const SizedBox(height: kMarginMd),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return Container();
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          ),
          CommentListScreen(newsId: widget.post.id),
          const SizedBox(
            height: kMarginLg,
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Bài đăng',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
