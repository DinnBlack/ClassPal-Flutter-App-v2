import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/utils/responsive.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_feature_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:classpal_flutter_app/features/student/views/student_edit_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/student/views/widgets/custom_student_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_scale_effect.dart';
import '../bloc/student_bloc.dart';
import 'student_dashboard_screen.dart';

class StudentListScreen extends StatefulWidget {
  static const route = 'StudentListScreen';
  final bool isCreateView;
  final bool isPickerView;
  final bool isRollCallView;
  final ValueChanged<List<String>>? onSelectionChanged;
  final ValueChanged<List<Map<String, int>>>? onStatusChanged;
  final List<ProfileModel>? studentsInGroup;
  final ValueChanged<bool>? onStudentListChanged;

  const StudentListScreen({
    super.key,
    this.isCreateView = false,
    this.isPickerView = false,
    this.isRollCallView = false,
    this.onSelectionChanged,
    this.onStatusChanged,
    this.studentsInGroup,
    this.onStudentListChanged,
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

    widget.onSelectionChanged?.call(selectedStudentIds);
  }

  @override
  void initState() {
    super.initState();
    if (widget.studentsInGroup != null) {
      selectedStudentIds = widget.studentsInGroup!.map((s) => s.id).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.studentsInGroup != null &&
        widget.studentsInGroup!.isNotEmpty &&
        widget.isPickerView == false) {
      return _buildStudentsGroupListView(context);
    }

    return BlocBuilder<StudentBloc, StudentState>(
      builder: (context, state) {
        if (state is StudentFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StudentFetchFailure) {
          widget.onStudentListChanged?.call(false);
          return _buildErrorView(state.error);
        } else if (state is StudentFetchSuccess) {
          students = state.students;
          widget.onStudentListChanged?.call(students.isNotEmpty);
          if (students.isEmpty) {
            return _buildEmptyStudentView();
          } else {
            if (widget.isCreateView) {
              return _buildCreateListView();
            } else if (widget.isPickerView) {
              return _buildPickerView(context);
            } else if (widget.isRollCallView) {
              return StudentRollCallListScreen(
                students: students,
                onStatusChanged: widget.onStatusChanged,
              );
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

  Widget _buildStudentsGroupListView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thành viên',
          style: AppTextStyle.semibold(kTextSizeMd),
        ),
        const SizedBox(
          height: kMarginLg,
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            double itemHeight = 105;
            double itemWidth = (constraints.maxWidth -
                    ((Responsive.isMobile(context)
                                ? 4
                                : Responsive.isTablet(context)
                                    ? 5
                                    : 6) -
                            1) *
                        kPaddingMd) /
                (Responsive.isMobile(context)
                    ? 4
                    : Responsive.isTablet(context)
                        ? 5
                        : 6);

            return _buildGridView(
                widget.studentsInGroup!, itemHeight, itemWidth, false, true);
          },
        ),
      ],
    );
  }

  Widget _buildCreateListView() {
    if (students.isEmpty) {
      return _buildEmptyStudentView();
    }
    return ListView.separated(
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
              child: GestureDetector(
                onTap: () {
                  showCustomFeatureDialog(
                    context,
                    ['Chỉnh sửa học sinh', 'Hủy bỏ học sinh'],
                    [
                      () {
                        if (!Responsive.isMobile(context)) {
                          showCustomDialog(
                            context,
                            StudentEditScreen(
                              student: student,
                            ),
                          );
                        } else {
                          CustomPageTransition.navigateTo(
                              context: context,
                              page: StudentEditScreen(
                                student: student,
                              ),
                              transitionType:
                                  PageTransitionType.slideFromBottom);
                        }
                      },
                      () {
                        _showDeleteConfirmationDialog(context, student);
                      },
                    ],
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
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

  void _showDeleteConfirmationDialog(
      BuildContext context, ProfileModel student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: Text(
              "Bạn có chắc muốn hủy bỏ học sinh '${student.displayName}' không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Đóng dialog
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<StudentBloc>()
                    .add(StudentDeleteStarted(studentId: student.id));
                Navigator.pop(context); // Đóng dialog sau khi xóa
              },
              child:
                  const Text("Xác nhận", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStudentListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final studentData = [...students, null];
          double itemHeight = 105;
          double itemWidth = (constraints.maxWidth - (4 - 1) * kPaddingMd) /
              (Responsive.isMobile(context)
                  ? 4
                  : Responsive.isTablet(context)
                      ? 5
                      : 6);

          return _buildGridView(
              studentData, itemHeight, itemWidth, false, false);
        },
      ),
    );
  }

  Widget _buildPickerView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        children: [
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
              double itemWidth = (constraints.maxWidth -
                      ((Responsive.isMobile(context)
                                  ? 4
                                  : Responsive.isTablet(context)
                                      ? 5
                                      : 6) -
                              1) *
                          kPaddingMd) /
                  (Responsive.isMobile(context)
                      ? 4
                      : Responsive.isTablet(context)
                          ? 5
                          : 6);

              return _buildGridView(
                  students, itemHeight, itemWidth, true, false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<ProfileModel?> studentData, double itemHeight,
      double itemWidth, bool isPicker, bool isGroup) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context)
            ? 4
            : Responsive.isTablet(context)
                ? 5
                : 6,
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
              if (!Responsive.isMobile(context)) {
                showCustomDialog(context, const StudentCreateScreen());
              } else {
                CustomPageTransition.navigateTo(
                    context: context,
                    page: const StudentCreateScreen(),
                    transitionType: PageTransitionType.slideFromBottom);
              }
            },
          );
        } else if (isPicker) {
          bool isSelected = selectedStudentIds.contains(student.id);
          return CustomStudentListItem(
            isPicker: isPicker,
            isSelected: isSelected,
            student: student,
            onSelectionChanged: (isSelected) {
              _toggleSelection(student.id);
            },
          );
        } else if (isGroup) {
          return CustomStudentListItem(
            isGroup: true,
            student: student,
          );
        } else {
          return CustomStudentListItem(
            student: student,
            onTap: () {
              if (!Responsive.isMobile(context)) {
                showCustomDialog(
                  context,
                  StudentDashboardScreen(
                    student: student,
                  ),
                );
              } else {
                CustomPageTransition.navigateTo(
                    context: context,
                    page: StudentDashboardScreen(
                      student: student,
                    ),
                    transitionType: PageTransitionType.slideFromBottom);
              }
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
            'assets/images/empty_student.png',
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

class StudentRollCallListScreen extends StatefulWidget {
  final List<ProfileModel> students;
  final ValueChanged<List<Map<String, int>>>? onStatusChanged;

  const StudentRollCallListScreen({
    super.key,
    required this.students,
    this.onStatusChanged,
  });

  @override
  State<StudentRollCallListScreen> createState() =>
      _StudentRollCallListScreenState();
}

class _StudentRollCallListScreenState extends State<StudentRollCallListScreen> {
  final List<String> statuses = ['Đi học', 'Vắng', 'Trễ'];
  final Map<String, int> studentStatusMap = {};

  @override
  void initState() {
    super.initState();
    for (var student in widget.students) {
      studentStatusMap[student.id] = 0;
    }

    // Gửi danh sách trạng thái ban đầu (tất cả đều đi học)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyStatusChanged();
    });
  }

  void _notifyStatusChanged() {
    if (widget.onStatusChanged != null) {
      List<Map<String, int>> statusList = studentStatusMap.entries
          .map((entry) => {entry.key: entry.value})
          .toList();
      widget.onStatusChanged!(statusList);
    }
  }

  void _toggleStatus(String studentId) {
    setState(() {
      int currentIndex = studentStatusMap[studentId] ?? 0;
      studentStatusMap[studentId] = (currentIndex + 1) % statuses.length;
    });

    // Chuyển đổi Map thành List<Map<String, int>>
    List<Map<String, int>> statusList = studentStatusMap.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    widget.onStatusChanged?.call(statusList);
    _notifyStatusChanged();
  }

  Widget _buildRollCallListView() {
    if (widget.students.isEmpty) {
      return Center(
        child: Text(
          'Không có học sinh',
          style: AppTextStyle.medium(kTextSizeSm),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      itemCount: widget.students.length,
      itemBuilder: (context, index) {
        final student = widget.students[index];
        final statusIndex = studentStatusMap[student.id] ?? 0;
        final statusText = statuses[statusIndex];

        return CustomListItem(
          isAnimation: false,
          title: student.displayName,
          leading: CustomAvatar(profile: student),
          trailing: GestureDetector(
            onTap: () => _toggleStatus(student.id),
            child: Text(
              statusText,
              style: AppTextStyle.medium(
                kTextSizeSm,
                _getStatusColor(statusIndex),
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginLg),
    );
  }

  Color _getStatusColor(int index) {
    switch (index) {
      case 1:
        return Colors.red; // Vắng
      case 2:
        return Colors.orange; // Trễ
      default:
        return kPrimaryColor; // Đi học
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildRollCallListView();
  }
}
