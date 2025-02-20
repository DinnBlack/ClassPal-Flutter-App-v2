import 'package:classpal_flutter_app/features/invitation/views/invitation_form.dart';
import 'package:flutter/material.dart';
import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../teacher/views/teacher_list_screen.dart';

class ClassConnectTeacherPage extends StatelessWidget {
  const ClassConnectTeacherPage({super.key});

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
            const SizedBox(
              height: kMarginSm,
            ),
            Text(
              'Thêm giáo viên vào lớp',
              style: AppTextStyle.semibold(kTextSizeSm),
            ),
            const SizedBox(
              height: kMarginMd,
            ),
             CustomButton(
              text: 'Thêm giáo viên',
              onTap: () {
                showInvitationForm(context, null, 'Teacher', null);
              },
            ),
            const SizedBox(
              height: kMarginXl,
            ),
            const TeacherListScreen(isTeacherConnectView: true,)
          ],
        ),
      ),
    );
  }
}
