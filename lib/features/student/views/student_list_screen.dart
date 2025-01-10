import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_bottom_sheet.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_list_item.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_scale_effect.dart';
import '../models/student_model.dart';

class StudentListScreen extends StatelessWidget {
  final bool isListView;
  final bool isCreateListView;
  final List<StudentModel> students;
  static const route = 'StudentListScreen';

  const StudentListScreen({
    super.key,
    this.isListView = false,
    required this.students,
    this.isCreateListView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCreateListView) {
      return _buildCreateListView();
    } else {
      return _buildStudentListView(context);
    }
  }

  Widget _buildCreateListView() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      itemCount: students.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(height: kMarginMd),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Học sinh của bạn',
                  style: AppTextStyle.medium(kTextSizeSm),
                ),
              ),
            ],
          );
        } else if (index == students.length + 1) {
          return const SizedBox(height: kMarginLg);
        } else {
          final student = students[index - 1];
          return CustomListItem(
            isAnimation: false,
            title: student.name,
            leading: CustomAvatar(
              user: student,
            ),
            trailing: GestureDetector(
              onTap: () {
                print(1);
              },
              child: CustomScaleEffect(
                child: Container(
                  padding: const EdgeInsets.all(kPaddingMd),
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.pencil,
                    size: 16,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginLg),
    );
  }


  Widget _buildStudentListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (4 - 1) * kPaddingMd) / 4;

          if (isListView) {
            return _buildListView(studentData);
          } else {
            return _buildGridView(studentData, itemHeight, itemWidth);
          }
        },
      ),
    );
  }

  Widget _buildListView(List<StudentModel?> studentData) {
    // ListView layout
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: studentData.length,
      itemBuilder: (context, index) {
        final student = studentData[index];
        if (student == null) {
          return const CustomStudentListItem(
            addItem: true,
          );
        } else {
          return CustomStudentListItem(
            student: student,
          );
        }
      },
    );
  }

  Widget _buildGridView(List<StudentModel?> studentData, double itemHeight,
      double itemWidth) {
    // GridView layout
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: kPaddingMd,
        mainAxisSpacing: kPaddingMd,
        childAspectRatio: itemWidth / itemHeight,
      ),
      itemCount: studentData.length,
      itemBuilder: (context, index) {
        final student = studentData[index];
        if (student == null) {
          return CustomStudentListItem(
            addItem: true,
            onTap: () {
              CustomBottomSheet.showCustomBottomSheet(
                  context, StudentCreateScreen(students: students));
            },
          );
        } else {
          return CustomStudentListItem(
            student: student,
          );
        }
      },
    );
  }
}

