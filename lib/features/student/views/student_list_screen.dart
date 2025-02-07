import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_feature_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:classpal_flutter_app/features/student/views/student_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_scale_effect.dart';
import '../bloc/student_bloc.dart';

class StudentListScreen extends StatefulWidget {
  final bool isCreateListView;
  final bool isPickerView;
  final ValueChanged<List<String>>? onSelectionChanged;
  static const route = 'StudentListScreen';

  const StudentListScreen({
    super.key,
    this.isCreateListView = false,
    this.isPickerView = false,
    this.onSelectionChanged,
  });

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late List<ProfileModel> students;
  List<String> selectedStudentIds = [];

  void _toggleSelection(String studentId) {
    setState(() {
      if (selectedStudentIds.contains(studentId)) {
        selectedStudentIds.remove(studentId);
      } else {
        selectedStudentIds.add(studentId);
      }
    });

    widget.onSelectionChanged?.call(selectedStudentIds); // Gửi danh sách đã chọn
  }

  @override
  void initState() {
    super.initState();
    // Fetch students when screen is loaded
    context.read<StudentBloc>().add(StudentFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StudentFetchFailure) {
          return _buildErrorView(state.error);
        } else if (state is StudentFetchSuccess) {
          students = state.students;
          if (students.isEmpty) {
            return _buildEmptyStudentView();
          } else {
            if (widget.isCreateListView) {
              return _buildCreateListView();
            } else if (widget.isPickerView) {
              return _buildPickerView(context);
            } else {
              return _buildStudentListView(context);
            }
          }
        } else {
          return _buildEmptyStudentView();
        }
      },
    );
  }

  Widget _buildCreateListView() {
    if (students.isEmpty) {
      return _buildEmptyStudentView();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      itemCount: students.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              const SizedBox(height: kMarginMd),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Học sinh của bạn',
                  style: AppTextStyle.medium(kTextSizeSm),
                ),
              ),
            ],
          );
        } else if (index == students.length + 1) {
          return const SizedBox(height: kMarginLg);
        } else {
          final student = students[index - 1];
          return CustomListItem(
            isAnimation: false,
            title: student.displayName,
            leading: CustomAvatar(
              profile: student,
            ),
            trailing: CustomScaleEffect(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    showCustomFeatureDialog(
                      context,
                      ['Chỉnh sửa học sinh', 'Hủy bỏ học sinh'],
                      [
                        () {
                          CustomPageTransition.navigateTo(
                              context: context,
                              page: StudentEditScreen(
                                student: student,
                              ),
                              transitionType:
                                  PageTransitionType.slideFromBottom);
                        },
                        () {
                          CustomPageTransition.navigateTo(
                              context: context,
                              page: StudentEditScreen(
                                student: student,
                              ),
                              transitionType:
                                  PageTransitionType.slideFromBottom);
                        },
                      ],
                    );
                  },
                  child: const Icon(
                    FontAwesomeIcons.pencil,
                    size: 16,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
          );
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginLg),
    );
  }

  Widget _buildStudentListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (4 - 1) * kPaddingMd) / 4;

          return _buildGridView(studentData, itemHeight, itemWidth, false);
        },
      ),
    );
  }

  Widget _buildPickerView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        children: [
          const SizedBox(height: kMarginMd),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Học sinh của bạn',
              style: AppTextStyle.medium(kTextSizeSm),
            ),
          ),
          const SizedBox(height: kMarginLg),
          LayoutBuilder(
            builder: (context, constraints) {
              double itemHeight = 105;
              double itemWidth =
                  (constraints.maxWidth - (4 - 1) * kPaddingMd) / 4;

              return _buildGridView(students, itemHeight, itemWidth, true);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<ProfileModel?> studentData, double itemHeight,
      double itemWidth, bool isPicker) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: kPaddingMd,
        mainAxisSpacing: kPaddingMd,
        childAspectRatio: itemWidth / itemHeight,
      ),
      itemCount: studentData.length,
      itemBuilder: (context, index) {
        final student = studentData[index];
        if (student == null) {
          return CustomStudentListItem(
            addItem: true,
            onTap: () {
              CustomPageTransition.navigateTo(
                  context: context,
                  page: const StudentCreateScreen(),
                  transitionType: PageTransitionType.slideFromBottom);
            },
          );
        } else {
          return CustomStudentListItem(
            isPicker: isPicker,
            student: student,
            onSelectionChanged: (isSelected) {
              _toggleSelection(student.id);
            },
          );
        }
      },
    );
  }
}

Widget _buildEmptyStudentView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_student_view.png',
            height: 200,
          ),
          const SizedBox(height: kMarginLg),
          Text(
            'Thêm học sinh của bạn nào!',
            style: AppTextStyle.bold(kTextSizeLg),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kMarginSm),
          Text(
            'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
            style: AppTextStyle.medium(kTextSizeXs),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildErrorView(String errorMessage) {
  return Center(
    child: Text(
      errorMessage,
      style: AppTextStyle.medium(kTextSizeLg),
    ),
  );
}
