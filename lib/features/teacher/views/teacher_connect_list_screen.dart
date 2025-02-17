import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_list_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';
import '../../invitation/views/invitation_form.dart';
import '../../student/models/student_model.dart';
import '../../student/repository/student_data.dart';

class TeacherConnectListScreen extends StatelessWidget {
  const TeacherConnectListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TeacherListScreen(isTeacherConnectView: true,),
      ],
    );
  }
}
