import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_tab_bar.dart';
import 'class_connect_page/class_connect_parent_page.dart';
import 'class_connect_page/class_connect_student_page.dart';
import 'class_connect_page/class_connect_teacher_page.dart';

class ClassConnectScreen extends StatefulWidget {
  final int? pageIndex;
  const ClassConnectScreen({super.key, this.pageIndex = 0});

  @override
  State<ClassConnectScreen> createState() => _ClassConnectScreenState();
}

class _ClassConnectScreenState extends State<ClassConnectScreen> {
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
            tabTitles: const ['Gia đình', 'Học sinh', 'Giáo viên'],
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
              children: const [
                ClassConnectParentPage(),
                ClassConnectStudentPage(),
                ClassConnectTeacherPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return  CustomAppBar(
      title: 'Kết nối lớp',
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

