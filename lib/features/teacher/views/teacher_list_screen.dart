import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_create_screen.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../class/models/class_model.dart';
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
        } else if (widget.isTeacherConnectView!) {
          return _buildListTeacherConnectView(teachers);
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
          subtitle: teacher.userId == null ? 'Giáo viên chưa tham gia': null,
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
          hasTrailingArrow: true,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }

  Widget _buildListTeacherConnectView(List<ProfileModel> teachers) {
    return FutureBuilder<ClassModel?>(
      future: ClassService().getCurrentClass(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Không thể tải dữ liệu lớp học.'));
        }

        final currentClass = snapshot.data!;
        final ownerTeacher =
            teachers.firstWhereOrNull((t) => t.id == currentClass.creatorId);
        final joinedTeachers = teachers
            .where((t) => t.userId != null && t.id != currentClass.creatorId)
            .toList();
        final invitedTeachers =
            teachers.where((t) => t.userId == null).toList();

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: kMarginMd),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Chủ sở hữu
            if (ownerTeacher != null) ...[
              Text('Chủ sở hữu', style: AppTextStyle.semibold(kTextSizeMd)),
              const SizedBox(
                height: kMarginMd,
              ),
              _buildTeacherList([ownerTeacher], isOwner: true),
            ],
            const SizedBox(
              height: kMarginLg,
            ),
            // Giáo viên đã tham gia
            if (joinedTeachers.isNotEmpty) ...[
              Text('Đã tham gia', style: AppTextStyle.semibold(kTextSizeMd)),
              const SizedBox(
                height: kMarginMd,
              ),
              _buildTeacherList(joinedTeachers),
            ],
            const SizedBox(
              height: kMarginLg,
            ),
            // Giáo viên đã mời
            if (invitedTeachers.isNotEmpty) ...[
              Text('Đã mời', style: AppTextStyle.semibold(kTextSizeMd)),
              const SizedBox(
                height: kMarginMd,
              ),
              _buildTeacherList(invitedTeachers),
            ],
          ],
        );
      },
    );
  }

// Widget hiển thị danh sách giáo viên
  Widget _buildTeacherList(List<ProfileModel> teachers,
      {bool isOwner = false}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      // Tránh cuộn trong ListView cha
      itemCount: teachers.length,
      itemBuilder: (context, index) {
        final teacher = teachers[index];
        return CustomListItem(
          title: teacher.displayName,
          subtitle: teacher.userId == null ? 'Giáo viên chưa tham gia' : null,
          isAnimation: false,
          leading: CustomAvatar(profile: teacher),
          onTap: isOwner || widget.isTeacherConnectView == true
              ? null
              : () {
                  CustomPageTransition.navigateTo(
                    context: context,
                    page: TeacherDetailScreen(teacher: teacher),
                    transitionType: PageTransitionType.slideFromBottom,
                  );
                },
          hasTrailingArrow: false,
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
