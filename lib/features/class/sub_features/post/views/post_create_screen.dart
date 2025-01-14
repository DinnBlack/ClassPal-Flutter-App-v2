import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCreateScreen extends StatefulWidget {
  static const route = 'PostCreateScreen';

  const PostCreateScreen({
    super.key,
  });

  @override
  _PostCreateScreenState createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [],
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Tạo bài đăng',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
          color: kGreyColor,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
