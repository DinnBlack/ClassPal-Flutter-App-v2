
import 'package:flutter/material.dart';

import '../../../core/config/app_constants.dart';
import '../repository/student_group_data.dart';
import 'widgets/custom_student_group_list_item.dart';

class StudentGroupListScreen extends StatelessWidget {
  const StudentGroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final groupData = studentGroups;

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
            // Include "Add New" button
            itemBuilder: (context, index) {
              if (index < groupData.length) {
                final group = groupData[index];
                return CustomStudentGroupListItem(group: group);
              } else {
                // "Add New" button
                return const CustomStudentGroupListItem(
                  addItem: true,
                );
              }
            },
          );
        },
      ),
    );
  }
}
