import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../post/views/post_list_screen.dart';
import '../../../post/views/widgets/custom_post_create_button.dart';
import '../../models/class_model.dart';

class ClassNewsPage extends StatelessWidget {
  final ClassModel currentClass;

  const ClassNewsPage({super.key, required this.currentClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: PostCreateButton(),
            ),
            SizedBox(
              height: kMarginLg,
            ),
            PostListScreen(),
            SizedBox(
              height: kMarginLg,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Bảng tin',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
