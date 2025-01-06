import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_avatar.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';
import '../../student/models/student_model.dart';
import '../../student/repository/student_data.dart';

class StudentConnectListScreen extends StatelessWidget {
  const StudentConnectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentsNotConnected =
    sampleStudent_1.where((student) => student.userId == null).toList();
    final studentsConnected =
    sampleStudent_1.where((student) => student.userId != null).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentList('Chưa kết nối', studentsNotConnected),
          const SizedBox(height: kMarginLg),
          _buildStudentList('Đã kết nối', studentsConnected),
        ],
      ),
    );
  }

  Widget _buildStudentList(String title, List<StudentModel> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${students.length})',
          style: AppTextStyle.semibold(kTextSizeMd),
        ),
        const SizedBox(height: kMarginLg),
        LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Column(
                  children: [
                    CustomListItem(
                      title: student.name,
                      leading: CustomStudentAvatar(
                        student: student,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
