import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../student/views/student_group_list_screen.dart';
import '../../../student/views/student_list_screen.dart';
import '../class_management_screen.dart';

class ClassDashboardPage extends StatelessWidget {
  const ClassDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kMarginMd,
            ),
            const StudentListScreen(),
            const SizedBox(
              height: kMarginLg,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Text(
                'Nhóm',
                style: AppTextStyle.semibold(kTextSizeMd),
              ),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const StudentGroupListScreen(),
            const SizedBox(
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
      title: 'Toán nâng cao',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      bottomWidget: ClassManagementScreen(
        isHorizontal: true,
      ),
      additionalHeight: 55,
    );
  }
}
