import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/post/views/post_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../models/class_model.dart';
import 'class_page/class_news_page.dart';
import 'class_page/class_schedule_page.dart';
import 'class_page/class_dashboard_page.dart';
import 'class_page/class_notification_page.dart';

class ClassScreen extends StatefulWidget {
  static const route = 'ClassScreen';
  final ClassModel currentClass;

  const ClassScreen({super.key, required this.currentClass});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

    _pages = [
      ClassDashboardPage(currentClass: widget.currentClass),
      const SizedBox.shrink(),
      ClassNewsPage(currentClass: widget.currentClass),
      // ClassSchedulePage(
      //   currentClass: widget.currentClass,
      // ),
      // ClassNotificationPage(currentClass: widget.currentClass),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == 1) {
      CustomPageTransition.navigateTo(context: context, page: const PostCreateScreen(), transitionType: PageTransitionType.slideFromBottom);
      return;
    }

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
      title: 'Lớp Học',
    ),
    TabItem(
      icon: FontAwesomeIcons.star,
      title: '',
    ),
    TabItem(
      icon: FontAwesomeIcons.newspaper,
      title: 'Bảng Tin',
    ),
  ];

  void _showFavoriteBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "This is the wishlist BottomSheet!",
                style: AppTextStyle.bold(kTextSizeXl),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomBarCreative(
        items: items,
        backgroundColor: kWhiteColor,
        color: kGreyColor,
        colorSelected: kPrimaryColor,
        indexSelected: _currentIndex,
        titleStyle: AppTextStyle.medium(kTextSizeXxs),
        onTap: _onTabTapped,
      ),
    );
  }
}
