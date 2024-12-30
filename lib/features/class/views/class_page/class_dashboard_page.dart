import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../student/views/student_group_list_screen.dart';
import '../../../student/views/student_list_screen.dart';
import '../class_connect_screen.dart';
import '../class_management_screen.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';

class ClassDashboardPage extends StatefulWidget {
  const ClassDashboardPage({super.key});

  @override
  State<ClassDashboardPage> createState() => _ClassDashboardPageState();
}

class _ClassDashboardPageState extends State<ClassDashboardPage> {
  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Kết nối gia đình',
        'Kết nối học sinh',
        'Thêm giáo viên',
        'Học sinh',
        'Môn học',
        'Thông tin lớp học',
        'Kết thúc lớp học'
      ],
      [
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(pageIndex: 0,),
          );
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(pageIndex: 1,),
          );
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(pageIndex: 2,),
          );
        },
        () {
          print('Học sinh');
        },
        () {
          print('Môn học');
        },
        () {
          print('Thông tin lớp học');
        },
        () {
          print('Kết thúc lớp học');
        },
      ],
    );
  }

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
          _showFeatureDialog(context);
        },
      ),
      bottomWidget: ClassManagementScreen(
        isHorizontal: true,
      ),
      additionalHeight: 55,
    );
  }
}
