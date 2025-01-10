import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:classpal_flutter_app/features/class/views/class_information_screen.dart';
import 'package:classpal_flutter_app/features/class/sub_features/schedule/views/schedule_screen.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_bottom_sheet.dart';
import '../../../student/views/student_group_list_screen.dart';
import '../../../student/views/student_list_screen.dart';
import '../../models/class_model.dart';
import '../class_connect/class_connect_screen.dart';
import '../class_management_screen.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';

class ClassDashboardPage extends StatefulWidget {
  final ClassModel currentClass;

  const ClassDashboardPage({super.key, required this.currentClass});

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
        'Lịch học',
        'Môn học',
        'Thông tin lớp học',
        'Kết thúc lớp học'
      ],
      [
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(
              pageIndex: 0,
            ),
          );
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(
              pageIndex: 1,
            ),
          );
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassConnectScreen(
              pageIndex: 2,
            ),
          );
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            StudentCreateScreen(
              students: widget.currentClass.students,
            ),
          );
        },
            () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            ScheduleScreen(currentClass: widget.currentClass,
            ),
          );
        },
        () {
          print('Môn học');
        },
        () {
          CustomBottomSheet.showCustomBottomSheet(
            context,
            const ClassInformationScreen(),
          );
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
      body: widget.currentClass.students.isEmpty
          ? _buildEmptyStudentView()
          : _buildStudentListView(),
    );
  }

  Widget _buildEmptyStudentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_student_view.png',
              height: 200,
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Thêm học sinh của bạn nào!',
              style: AppTextStyle.bold(kTextSizeLg),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginSm),
            Text(
              'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
              style: AppTextStyle.medium(kTextSizeXs),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginLg),
            CustomButton(
              text: 'Thêm học viên',
              onTap: () {
                CustomBottomSheet.showCustomBottomSheet(
                    context,
                    StudentCreateScreen(
                      students: widget.currentClass.students,
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStudentListView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: kMarginMd,
          ),
          StudentListScreen(students: widget.currentClass.students),
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
          StudentGroupListScreen(
            currentClass: widget.currentClass,
          ),
          const SizedBox(
            height: kMarginLg,
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    bool hasStudents = widget.currentClass.students.isNotEmpty;

    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: widget.currentClass.name,
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
      bottomWidget:
          hasStudents ? ClassManagementScreen(isHorizontal: true) : null,
      additionalHeight: hasStudents ? 55 : 0,
    );
  }
}
