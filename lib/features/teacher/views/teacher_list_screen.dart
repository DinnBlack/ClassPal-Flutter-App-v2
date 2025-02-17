import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_create_screen.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../profile/model/profile_model.dart';
import '../bloc/teacher_bloc.dart';

class TeacherListScreen extends StatefulWidget {
  final bool? isTeacherConnectView;
  final bool? isTeacherAssignmentView;

  const TeacherListScreen(
      {super.key,
      this.isTeacherConnectView = false,
      this.isTeacherAssignmentView = false});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  final Set<String> _selectedTeacherIds = {};

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(TeacherFetchStarted());
  }

  // Hàm này sẽ thay đổi trạng thái của giáo viên khi nhấn vào icon plus
  void _toggleTeacherSelection(String teacherId) {
    setState(() {
      if (_selectedTeacherIds.contains(teacherId)) {
        _selectedTeacherIds.remove(teacherId);
      } else {
        _selectedTeacherIds.add(teacherId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherBloc, TeacherState>(
      builder: (context, state) {
        if (state is TeacherFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TeacherFetchFailure ||
            state is! TeacherFetchSuccess) {
          return _buildEmptyTeacherView();
        }

        final teachers = (state).teachers;

        if (teachers.isEmpty) {
          return _buildEmptyTeacherView();
        } else if (widget.isTeacherAssignmentView!) {
          return _buildListTeacherAssignmentView(teachers);
        } else {
          return _buildListTeacherView(teachers);
        }
      },
    );
  }

  Widget _buildListTeacherView(List<ProfileModel> teachers) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: kMarginMd),
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return CustomListItem(
          title: teacher.displayName,
          isAnimation: !(widget.isTeacherConnectView ?? false),
          leading: CustomAvatar(profile: teacher),
          onTap: widget.isTeacherConnectView == true
              ? null
              : () {
                  CustomPageTransition.navigateTo(
                    context: context,
                    page: TeacherDetailScreen(teacher: teacher),
                    transitionType: PageTransitionType.slideFromBottom,
                  );
                },
          hasTrailingArrow: !(widget.isTeacherConnectView ?? false),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }

  Widget _buildListTeacherAssignmentView(List<ProfileModel> teachers) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: kMarginMd),
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        bool isSelected = _selectedTeacherIds.contains(teacher.id);

        return CustomListItem(
          title: teacher.displayName,
          isAnimation: false,
          leading: CustomAvatar(profile: teacher),
          trailing: GestureDetector(
            onTap: () {
              _toggleTeacherSelection(teacher.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMd),
              child: Icon(
                isSelected ? FontAwesomeIcons.check : FontAwesomeIcons.plus,
                size: 16,
                color: isSelected ? kPrimaryColor : kPrimaryLightColor,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }


  Widget _buildEmptyTeacherView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_teacher.jpg', height: 200),
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
    );
  }
}
