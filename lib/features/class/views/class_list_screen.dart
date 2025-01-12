import 'package:flutter/material.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../models/class_model.dart';

class ClassListScreen extends StatelessWidget {
  final List<ClassModel> classes;

  const ClassListScreen({
    super.key,
    required this.classes,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final currentClass = classes[index];
        String teachersText =
            currentClass.name;

        return CustomListItem(
          leading: CustomAvatar(
            profile: currentClass,
          ),
          title: currentClass.name,
          subtitle: teachersText,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }
}
