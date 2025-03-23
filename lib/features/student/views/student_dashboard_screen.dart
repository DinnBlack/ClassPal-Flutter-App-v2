import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/responsive.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_edit_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../core/widgets/custom_feature_dialog.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../class/sub_features/grade/views/grade_student_list_screen.dart';
import '../../class/sub_features/subject/views/subject_list_screen.dart';
import '../../class/views/class_connect/class_connect_screen.dart';
import '../bloc/student_bloc.dart';

class StudentDashboardScreen extends StatefulWidget {
  final ProfileModel student;
  final int? pageIndex;

  const StudentDashboardScreen(
      {super.key, this.pageIndex = 0, required this.student});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  final PageController _pageController = PageController();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex ?? 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(_currentIndex);
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.ease,
    );
  }

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Chỉnh sửa học sinh',
        'Kết nối phụ huynh',
        'Xóa học sinh',
      ],
      [
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              StudentEditScreen(
                student: widget.student,
              ),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: StudentEditScreen(
                student: widget.student,
              ),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              const ClassConnectScreen(
                pageIndex: 0,
              ),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const ClassConnectScreen(
                pageIndex: 0,
              ),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
        () {
          _showDeleteConfirmationDialog(context, widget.student);
        },
      ],
    );
  }

  double calculateTabBarWidthRatio(BuildContext context, double maxWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    double ratio = maxWidth / screenWidth;
    return ratio > 1 ? 1 : ratio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Responsive.isMobile(context) ? kWhiteColor : kTransparentColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          CustomTabBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            tabTitles: const ['Điểm', 'Thống kê'],
            tabBarWidthRatio: Responsive.isMobile(context)
                ? 0.9
                : calculateTabBarWidthRatio(context, 650),
            lineHeight: 4,
            linePadding: 0,
            tabBarHeight: 40,
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                SubjectListScreen(
                  isGradeStudentView: true,
                  studentId: widget.student.id,
                ),
                GradeStudentListScreen(
                  studentId: widget.student.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      title: widget.student.displayName,
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {
          _showFeatureDialog(context);
        },
      ),
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<StudentBloc>()
                    .add(StudentDeleteStarted(studentId: student.id));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:
                  const Text("Xác nhận", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
