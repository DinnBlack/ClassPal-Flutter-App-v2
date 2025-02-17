import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/class/views/class_list_screen.dart';
import 'package:flutter/material.dart';
import '../../core/utils/app_text_style.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/school/views/school_list_screen.dart';

class TeacherView extends StatefulWidget {
  static const route = 'TeacherView';
  final UserModel user;

  const TeacherView({
    super.key,
    required this.user,
  });

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  final classService = ClassService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kMarginLg,
            ),
            Text(
              'Tham gia trường học',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const SchoolListScreen(isTeacherView: true,),
            const SizedBox(
              height: kMarginLg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lớp học cá nhân',
                  style: AppTextStyle.semibold(kTextSizeMd),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ClassCreateScreen.route,
                    );
                  },
                  child: Text(
                    '+ Thêm lớp học',
                    style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const ClassListScreen(),
          ],
        ),
      ),
    );
  }
}
