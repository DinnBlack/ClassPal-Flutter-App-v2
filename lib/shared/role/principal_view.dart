import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/class/views/class_list_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_create_screen.dart';
import 'package:flutter/material.dart';
import '../../core/utils/app_text_style.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/school/views/school_list_screen.dart';

class PrincipalView extends StatefulWidget {
  static const route = 'PrincipalView';
  final UserModel user;

  const PrincipalView({
    super.key,
    required this.user,
  });

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Trường học',
                  style: AppTextStyle.semibold(kTextSizeMd),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SchoolCreateScreen.route,
                    );
                  },
                  child: Text(
                    '+ Thêm trường học',
                    style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const SchoolListScreen(),
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
            const SizedBox(
              height: kMarginLg,
            ),
          ],
        ),
      ),
    );
  }
}
