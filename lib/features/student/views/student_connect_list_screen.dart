import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_button.dart';
import '../../invitation/repository/invitation_service.dart';
import '../../invitation/views/qr_code_screen.dart';
import '../../profile/model/profile_model.dart';
import '../bloc/student_bloc.dart';

class StudentConnectListScreen extends StatefulWidget {
  const StudentConnectListScreen({super.key});

  @override
  State<StudentConnectListScreen> createState() =>
      _StudentConnectListScreenState();
}

class _StudentConnectListScreenState extends State<StudentConnectListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(StudentFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StudentFetchSuccess) {
          int totalStudents = state.students.length;
          List<ProfileModel> disconnectedStudents =
              state.students.where((s) => s.userId == null).toList();
          List<ProfileModel> connectedStudents =
              state.students.where((s) => s.userId != null).toList();

          double percentage = totalStudents > 0
              ? (connectedStudents.length / totalStudents) * 100
              : 0; // Tránh chia cho 0

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kMarginXl),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: AppTextStyle.semibold(40, kPrimaryColor),
                    ),
                  ),
                  const SizedBox(height: kMarginSm),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Học sinh đã được kết nối',
                      style: AppTextStyle.semibold(kTextSizeSm),
                    ),
                  ),
                  const SizedBox(
                    height: kMarginMd,
                  ),
                  CustomButton(
                    text: 'Mã lớp học',
                    onTap: () async {
                      final code =
                          await InvitationService().generateGroupCode();
                      if (code != null) {
                        if (!Responsive.isMobile(context)) {
                          showCustomDialog(context, QRCodeScreen(code: code));
                        } else {
                          CustomPageTransition.navigateTo(
                              context: context,
                              page: QRCodeScreen(code: code),
                              transitionType:
                                  PageTransitionType.slideFromBottom);
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: kMarginXl,
                  ),
                  _buildStudentList('Chưa kết nối', disconnectedStudents),
                  const SizedBox(height: kMarginLg),
                  _buildStudentList('Đã kết nối', connectedStudents),
                ],
              ),
            ),
          );
        } else if (state is StudentFetchFailure) {
          return Center(child: Text("Lỗi: ${state.error}"));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildStudentList(String title, List<ProfileModel> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${students.length})',
          style: AppTextStyle.semibold(kTextSizeMd),
        ),
        const SizedBox(height: kMarginLg),
        ListView.separated(
          separatorBuilder: (context, index) =>
              const SizedBox(height: kMarginMd),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return CustomListItem(
              title: student.displayName,
              leading:
                  const CustomAvatar(imageAsset: 'assets/images/student.jpg'),
            );
          },
        ),
      ],
    );
  }
}
