import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/config/app_constants.dart';
import '../../core/utils/app_text_style.dart';
import '../../features/parent/views/parent_page/parent_main_page.dart';
import '../../features/parent/views/parent_page/parent_management_page.dart';

class ParentView extends StatefulWidget {
  const ParentView({
    super.key,
  });

  @override
  State<ParentView> createState() => _ParentViewState();
}

class _ParentViewState extends State<ParentView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          ParentMainPage(),
          ParentManagementPage(),
        ],
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
