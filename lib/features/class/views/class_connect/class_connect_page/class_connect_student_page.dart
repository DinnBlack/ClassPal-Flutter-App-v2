import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/student/views/student_connect_list_screen.dart';
import 'package:flutter/material.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';

class ClassConnectStudentPage extends StatelessWidget {
  const ClassConnectStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(
              height: kMarginXl,
            ),
            Text(
              '56%',
              style: AppTextStyle.semibold(40, kPrimaryColor),
            ),
            const SizedBox(
              height: kMarginSm,
            ),
            Text(
              'Học sinh đã được kết nối',
              style: AppTextStyle.semibold(kTextSizeSm),
            ),
            const SizedBox(
              height: kMarginMd,
            ),
            CustomButton(
              text: 'Mã lớp học',
            ),
            const SizedBox(
              height: kMarginXl,
            ),
            const StudentConnectListScreen(),
          ],
        ),
      ),
    );
  }
}
