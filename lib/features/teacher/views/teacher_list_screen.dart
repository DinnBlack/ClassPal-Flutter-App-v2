import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../models/teacher_model.dart';

class TeacherListScreen extends StatelessWidget {
  final List<TeacherModel> teachers;

  const TeacherListScreen({
    super.key,
    required this.teachers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return CustomListItem(
          leading: CustomAvatar(
            user: teacher,
          ),
          title: teacher.name,
          subtitle: teacher.userId,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }
}
