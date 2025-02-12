import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_create_screen.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../profile/model/profile_model.dart';
import '../bloc/teacher_bloc.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  late List<ProfileModel> teachers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherBloc, TeacherState>(
      builder: (context, state) {
        if (state is TeacherFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherFetchFailure) {
          return _buildEmptyTeacherView();
        } else if (state is TeacherFetchSuccess) {
          teachers = state.teachers;
          if (teachers.isEmpty) {
            return _buildEmptyTeacherView();
          } else {
            return _buildListTeacherView();
          }
        } else {
          return _buildEmptyTeacherView();
        }
      },
    );
  }

  Widget _buildListTeacherView() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      itemCount: teachers.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: kMarginMd);
        } else if (index == teachers.length + 1) {
          return const SizedBox(height: kMarginMd);
        } else {
          final teacher = teachers[index - 1];
          return CustomListItem(
            title: teacher.displayName,
            leading: CustomAvatar(
              profile: teacher,
            ),
            onTap: () {
              CustomPageTransition.navigateTo(
                  context: context,
                  page: TeacherDetailScreen(
                    teacher: teacher,
                  ),
                  transitionType: PageTransitionType.slideFromBottom);
            },
            hasTrailingArrow: true,
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginLg),
    );
  }

  Widget _buildEmptyTeacherView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_student.png',
              height: 200,
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Thêm giáo viên để quản lý lớp học!',
              style: AppTextStyle.bold(kTextSizeLg),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginSm),
            Text(
              'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
              style: AppTextStyle.medium(kTextSizeXs),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginLg),
            CustomButton(
              text: 'Thêm Giáo viên',
              onTap: () {
                CustomPageTransition.navigateTo(
                  context: context,
                  page: const TeacherCreateScreen(),
                  transitionType: PageTransitionType.slideFromBottom,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
