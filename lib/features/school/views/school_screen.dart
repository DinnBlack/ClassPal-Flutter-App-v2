import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:classpal_flutter_app/features/school/views/school_page/school_directory_page.dart';
import 'package:classpal_flutter_app/features/school/views/school_page/school_story_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';

class SchoolScreen extends StatefulWidget {
  static const route = 'SchoolScreen';
  final SchoolModel school;

  const SchoolScreen({super.key, required this.school});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    ClassService().getAllSchoolClass();
    _pageController = PageController(initialPage: _currentIndex);

    _pages = [
      SchoolStoryPage(
        school: widget.school,
      ),
      SchoolDirectoryPage(
        school: widget.school,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  static List<TabItem> items = [
    const TabItem(
      icon: FontAwesomeIcons.school,
      title: 'Trường học',
    ),
    const TabItem(
      icon: FontAwesomeIcons.newspaper,
      title: 'Quản lý',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        backgroundColor: kWhiteColor,
        color: kGreyColor,
        paddingVertical: 10,
        iconSize: 18,
        colorSelected: kPrimaryColor,
        indexSelected: _currentIndex,
        titleStyle: AppTextStyle.medium(kTextSizeXxs),
        onTap: _onTabTapped,
      ),
    );
  }
}
