import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_tab_bar.dart';

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
    // Initialize the page controller after the widget tree is built
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
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          CustomTabBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
            tabTitles: const ['Gia đình', 'Học sinh', 'Giáo viên'],
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
    return const CustomAppBar(
      title: 'Kết nối lớp',
      leftWidget: InkWell(
        child: Icon(
          FontAwesomeIcons.xmark,
          color: kGreyColor,
        ),
      ),
    );
  }
}

class ClassConnectParentPage extends StatelessWidget {
  const ClassConnectParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nội dung cho trang Gia đình
    return Padding(
      padding: const EdgeInsets.all(kPaddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kết nối với phụ huynh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Thêm nội dung phụ huynh ở đây, ví dụ: danh sách phụ huynh, thông tin liên lạc
          const Text('Danh sách phụ huynh'),
          // Bạn có thể thêm một ListView hoặc các widgets khác cho nội dung.
        ],
      ),
    );
  }
}

class ClassConnectStudentPage extends StatelessWidget {
  const ClassConnectStudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nội dung cho trang Học sinh
    return Padding(
      padding: const EdgeInsets.all(kPaddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kết nối với học sinh',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Thêm nội dung học sinh ở đây, ví dụ: danh sách học sinh, thông tin liên lạc
          const Text('Danh sách học sinh'),
          // Thêm danh sách học sinh hoặc các widgets khác.
        ],
      ),
    );
  }
}

class ClassConnectTeacherPage extends StatelessWidget {
  const ClassConnectTeacherPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Nội dung cho trang Giáo viên
    return Padding(
      padding: const EdgeInsets.all(kPaddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kết nối với giáo viên',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Thêm nội dung giáo viên ở đây, ví dụ: danh sách giáo viên, thông tin liên lạc
          const Text('Danh sách giáo viên'),
          // Thêm danh sách giáo viên hoặc các widgets khác.
        ],
      ),
    );
  }
}
