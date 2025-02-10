import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../core/widgets/custom_feature_dialog.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../class/sub_features/grade/views/grade_student_list_screen.dart';
import '../../class/sub_features/subject/views/subject_list_screen.dart';
import '../../class/views/class_connect/class_connect_screen.dart';

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
          CustomPageTransition.navigateTo(
            context: context,
            page: StudentEditScreen(
              student: widget.student,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassConnectScreen(
              pageIndex: 0,
            ),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          CustomTabBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            tabTitles: const ['Thông tin', 'Điểm', 'Thống kê'],
            tabBarWidthRatio: 0.9,
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
                Container(),
                Column(
                  children: [
                    const SizedBox(
                      height: kPaddingMd,
                    ),
                    SubjectListScreen(
                      isGradeStudentView: true,
                      studentId: widget.student.id,
                    ),
                  ],
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
}
