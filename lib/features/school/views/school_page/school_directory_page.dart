import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/features/class/views/class_create_screen.dart';
import 'package:classpal_flutter_app/features/teacher/views/teacher_create_batch_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/platform/platform_config.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_feature_dialog.dart';
import '../../../../core/widgets/custom_page_transition.dart';
import '../../../../core/widgets/custom_tab_bar.dart';
import '../../../class/bloc/class_bloc.dart';
import '../../../class/views/class_create_batch_screen.dart';
import '../../../class/views/class_list_screen.dart';
import '../../../teacher/bloc/teacher_bloc.dart';
import '../../../teacher/views/teacher_create_screen.dart';
import '../../../teacher/views/teacher_list_screen.dart';
import '../../models/school_model.dart';

class SchoolDirectoryPage extends StatefulWidget {
  final SchoolModel school;
  final bool isTeacherView;

  const SchoolDirectoryPage(
      {super.key, required this.school, this.isTeacherView = false});

  @override
  State<SchoolDirectoryPage> createState() => _SchoolDirectoryPageState();
}

class _SchoolDirectoryPageState extends State<SchoolDirectoryPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.isTeacherView) {
      context.read<TeacherBloc>().add(TeacherFetchStarted());
    }
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
        'Thêm lớp đồng loạt',
        'Thêm giáo viên',
        'Thêm giáo viên đồng loạt'
      ],
      [
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              const ClassCreateScreen(
                isClassSchoolCreateView: true,
              ),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const ClassCreateScreen(
                isClassSchoolCreateView: true,
              ),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              const ClassCreateBatchScreen(),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const ClassCreateBatchScreen(),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              const TeacherCreateScreen(),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const TeacherCreateScreen(),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
        () {
          if (!Responsive.isMobile(context)) {
            showCustomDialog(
              context,
              const TeacherCreateBatchScreen(),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const TeacherCreateBatchScreen(),
              transitionType: PageTransitionType.slideFromBottom,
            );
          }
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, widget.isTeacherView),
      body: !widget.isTeacherView
          ? Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: [_buildClassesTab(), _buildTeachersTab()],
                  ),
                ),
              ],
            )
          : _buildClassesTab(),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context, bool isTeacherView) {
    return CustomAppBar(
      height: Responsive.isMobile(context) ? kToolbarHeight : 70,
      backgroundColor: kWhiteColor,
      title: widget.isTeacherView ? 'Lớp học của bạn' : 'Quản lý',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          context.read<ClassBloc>().add(ClassPersonalFetchStarted());
          if (kIsWeb) {
            goBack();
          } else {
            Navigator.pop(context);
          }
        },
      ),
      additionalHeight: !isTeacherView ? 60 : 0,
      bottomWidget: !isTeacherView
          ? Column(
              children: [
                CustomTabBar(
                  currentIndex: _currentIndex,
                  onTabTapped: _onTabTapped,
                  tabTitles: const ['Lớp học', 'Giáo viên'],
                  tabBarWidthRatio: Responsive.isMobile(context) ? 0.9 : 0.3,
                  lineHeight: 4,
                  linePadding: 0,
                  tabBarHeight: 40,
                ),
                if (!Responsive.isMobile(context)) ...[
                  const SizedBox(
                    height: kMarginSm,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(width: 2, color: kGreyMediumColor)),
                    ),
                  )
                ]
              ],
            )
          : null,
      rightWidget: !widget.isTeacherView
          ? Responsive.isMobile(context)
              ? InkWell(
                  child: const Icon(FontAwesomeIcons.ellipsis),
                  onTap: () => _showFeatureDialog(context),
                )
              : GestureDetector(
                  onTap: () => _showFeatureDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tùy chọn',
                        style: AppTextStyle.semibold(kTextSizeMd),
                      ),
                      const SizedBox(
                        width: kMarginMd,
                      ),
                      const Icon(
                        FontAwesomeIcons.caretDown,
                      )
                    ],
                  ),
                )
          : null,
    );
  }

  Widget _buildClassesTab() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        children: [
          SizedBox(height: kMarginMd),
          Expanded(
            child: ClassListScreen(
              isClassSchoolView: true,
            ),
          ),
          SizedBox(height: kMarginMd),
        ],
      ),
    );
  }

  Widget _buildTeachersTab() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: TeacherListScreen(),
    );
  }
}
