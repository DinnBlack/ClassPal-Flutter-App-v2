import 'package:classpal_flutter_app/core/widgets/custom_bottom_sheet.dart';
import 'package:classpal_flutter_app/features/class/models/class_model.dart';
import 'package:classpal_flutter_app/features/student/models/student_group_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_group_create_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/config/app_constants.dart';
import 'widgets/custom_student_group_list_item.dart';

class StudentGroupListScreen extends StatelessWidget {
  final ClassModel currentClass;
  const StudentGroupListScreen({super.key, required this.currentClass});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final groupData = [];

          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (2 - 1) * 8.0) / 2;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: kPaddingMd,
              mainAxisSpacing: kPaddingMd,
              childAspectRatio: itemWidth / itemHeight,
            ),
            itemCount: groupData.length + 1,
            itemBuilder: (context, index) {
              if (index < groupData.length) {
                final group = groupData[index];
                return CustomStudentGroupListItem(group: group);
              } else {
                // "Add New" button
                return CustomStudentGroupListItem(
                  addItem: true,
                  onTap: () {
                    CustomBottomSheet.showCustomBottomSheet(context, StudentGroupCreateScreen(students: []));
                  },

                );
              }
            },
          );
        },
      ),
    );
  }
}
