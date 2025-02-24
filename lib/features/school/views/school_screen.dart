import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:classpal_flutter_app/features/school/views/school_page/school_directory_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../class/bloc/class_bloc.dart';
import 'school_page/school_post_page.dart';

class SchoolScreen extends StatefulWidget {
  static const route = 'SchoolScreen';
  final SchoolModel school;
  final bool isTeacherView;

  const SchoolScreen(
      {super.key, required this.school, this.isTeacherView = false});

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
    _pageController = PageController(initialPage: _currentIndex);

    _pages = [
      SchoolPostPage(
        school: widget.school,
        isTeacherView: widget.isTeacherView,
      ),
      SchoolDirectoryPage(
        school: widget.school,
        isTeacherView: widget.isTeacherView,
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

  static const List<TabItem> items = [
    TabItem(
      icon: FontAwesomeIcons.school,
      title: 'Bảng tin',
    ),
    TabItem(
      icon: FontAwesomeIcons.newspaper,
      title: 'Quản lý',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ClassBloc>().add(ClassPersonalFetchStarted());
        return true;
      },
      child: Scaffold(
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
          colorSelected: kPrimaryColor,
          indexSelected: _currentIndex,
          titleStyle: AppTextStyle.medium(kTextSizeXxs),
          onTap: _onTabTapped,
        ),
      ),
    );
  }
}
