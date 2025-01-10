import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_list_item.dart';

import '../models/student_model.dart';

class StudentListScreen extends StatelessWidget {
  final bool isListView;
  final List<StudentModel> students;
  static const route = 'StudentListScreen';

  const StudentListScreen({
    super.key,
    this.isListView = false,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (4 - 1) * kPaddingMd) / 4;

          if (isListView) {
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
          } else {
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
                  // Add item button for GridView
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