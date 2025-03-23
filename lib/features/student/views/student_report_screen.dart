import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../core/utils/responsive.dart';
import '../../class/sub_features/grade/views/grade_student_list_screen.dart';
import '../../class/sub_features/roll_call/views/roll_call_report_screen.dart';

class StudentReportScreen extends StatefulWidget {
  final String studentId;

  const StudentReportScreen({super.key, required this.studentId});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  final PageController _pageController = PageController();
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
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

  double calculateTabBarWidthRatio(BuildContext context, double maxWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    double ratio = maxWidth / screenWidth;
    return ratio > 1 ? 1 : ratio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !Responsive.isMobile(context) ? kTransparentColor : kBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          CustomTabBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            tabTitles: const ['Điểm số', 'Điểm danh'],
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
                GradeStudentListScreen(
                  studentId: widget.studentId,
                ),
                const RollCallReportScreen(
                  isStudentView: true,
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
      title: 'Báo cáo',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
