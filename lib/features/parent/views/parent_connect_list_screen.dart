import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';
import '../../class/views/widgets/custom_invite_dialog.dart';
import '../../student/models/student_model.dart';
import '../../student/repository/student_data.dart';

class ParentConnectListScreen extends StatelessWidget {
  const ParentConnectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final studentsWithNoParent =
    students.where((student) => student.parentId == null).toList();
    final studentsConnected =
    students.where((student) => student.parentId != null).toList();

    void showInviteDialog(BuildContext context, String name) {
      showCustomInviteDialog(context, 'Gửi lời mời', 'Đến P/h của $name');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStudentList('Chưa kết nối', studentsWithNoParent, 'Mời', showInviteDialog),
          const SizedBox(height: kMarginLg),
          _buildStudentList('Đã kết nối', studentsConnected, 'Xóa', null),
        ],
      ),
    );
  }

  Widget _buildStudentList(
      String title, List<StudentModel> students, String actionText, Function? onActionTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${students.length})',
          style: AppTextStyle.semibold(kTextSizeMd),
        ),
        const SizedBox(height: kMarginLg),
        LayoutBuilder(
          builder: (context, constraints) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Column(
                  children: [
                    CustomListItem(
                      title: 'P/h của ${student.name}',
                      leading: const CustomAvatar(
                        imageAsset: 'assets/images/parent.jpg',
                      ),
                      onTap: () {
                        if (onActionTap != null) {
                          onActionTap(context, student.name);
                        }
                      },
                      trailing: InkWell(

                        child: Text(
                          actionText,
                          style: AppTextStyle.medium(kTextSizeSm,
                              actionText == 'Mời' ? kPrimaryColor : kRedColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
