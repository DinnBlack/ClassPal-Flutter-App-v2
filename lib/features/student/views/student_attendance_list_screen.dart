import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_avatar.dart';
import 'package:flutter/material.dart';
import '../../student/repository/student_data.dart';

class StudentAttendanceListScreen extends StatelessWidget {
  const StudentAttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: studentData.length - 1,
            itemBuilder: (context, index) {
              final student = studentData[index];
              return Column(
                children: [
                  CustomListItem(
                    title: student?.name,
                    leading: CustomStudentAvatar(
                      student: student,
                      size: 40,
                    ),
                    trailing: Text(
                      'Đi học',
                      style: AppTextStyle.medium(kTextSizeMd, kPrimaryColor),
                    ),
                  ),
                  const SizedBox(height: kMarginLg),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
