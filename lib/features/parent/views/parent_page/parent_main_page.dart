import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../class/sub_features/post/views/post_list_screen.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() => _ParentMainPageState();
}

class _ParentMainPageState extends State<ParentMainPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

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
    return Column(
      children: [
        CustomTabBar(
          currentIndex: _currentIndex,
          onTabTapped: _onTabTapped,
          tabTitles: const ['Bài Đăng', 'Sự kiện'],
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
              PostListScreen(),
              Placeholder(),
            ],
          ),
        ),
      ],
    );
  }
}
