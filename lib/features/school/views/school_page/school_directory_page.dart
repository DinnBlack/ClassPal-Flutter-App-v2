import 'package:classpal_flutter_app/features/class/views/class_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';
import '../../../../core/widgets/custom_page_transition.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../class/views/class_list_screen.dart';
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

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Thêm lớp học',
        'Thêm giáo viên',
      ],
      [
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassCreateScreen(),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
        () {
          CustomPageTransition.navigateTo(
            context: context,
            page: const ClassCreateScreen(),
            transitionType: PageTransitionType.slideFromBottom,
          );
        },
      ],
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
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {
          _showFeatureDialog(context);
        },
      ),
    );
  }

  Widget _buildClassesTab() {
    return const Expanded(
      child: ClassListScreen(classes: []),
    );
  }

  Widget _buildTeachersTab() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: TeacherListScreen(teachers: []),
      ),
    );
  }
}
