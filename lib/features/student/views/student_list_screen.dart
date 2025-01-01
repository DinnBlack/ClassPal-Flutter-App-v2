import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_list_item.dart';
import 'package:flutter/material.dart';

import '../repository/student_data.dart';

class StudentListScreen extends StatelessWidget {
  final bool? isListView;
  static const route = 'StudentListScreen';

  const StudentListScreen({super.key, this.isListView = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (4 - 1) * 8.0) / 4;

          if (isListView ?? false) {
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
          } else {
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
        },
      ),
    );
  }
}
