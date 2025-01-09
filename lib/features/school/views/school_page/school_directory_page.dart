import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_list_item.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../teacher/views/teacher_list_screen.dart';
import '../../models/school_model.dart';

class SchoolDirectoryPage extends StatefulWidget {
  final SchoolModel school;

  const SchoolDirectoryPage({super.key, required this.school});

  @override
  State<SchoolDirectoryPage> createState() => _SchoolDirectoryPageState();
}

class _SchoolDirectoryPageState extends State<SchoolDirectoryPage> {
  final PageController _pageController = PageController();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
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
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          CustomTabBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            tabTitles: const ['Lớp học', 'Giáo viên'],
            tabBarWidthRatio: 1,
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
                _buildClassesTab(),
                _buildTeachersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Quản lý',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildClassesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.school.classes.map((classItem) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CustomListItem(
                leading: const Icon(Icons.class_),
                title: classItem.name,
                subtitle: 'Số lượng học sinh: ${classItem.teachers}',
                onTap: () {},
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTeachersTab() {
    return Expanded(
      child: TeacherListScreen(teachers: widget.school.teachers),
    );
  }
}
