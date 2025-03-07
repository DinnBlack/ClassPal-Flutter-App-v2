import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:classpal_flutter_app/features/auth/views/widgets/custom_select_role_item.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:classpal_flutter_app/shared/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custom_app_bar.dart';

class SelectRoleScreen extends StatefulWidget {
  static const route = 'SelectRoleScreen';

  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: kIsWeb
          ? null
          : CustomAppBar(
              leftWidget: _isLoggedIn
                  ? null
                  : InkWell(
                      child: const Icon(FontAwesomeIcons.arrowLeft),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
            ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth =
                constraints.maxWidth > 600 ? 600 : constraints.maxWidth;

            return SingleChildScrollView(
              child: Container(
                width: maxWidth,
                padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Bạn Là?',
                      style: AppTextStyle.bold(kTextSizeXl),
                    ),
                    const SizedBox(height: kMarginSm),
                    Text(
                      'Lựa chọn quyền của bạn để tiếp tục',
                      style: AppTextStyle.medium(kTextSizeXs),
                    ),
                    const SizedBox(height: kMarginLg),
                    CustomSelectRoleItem(
                      title: 'Ban giám hiệu',
                      subTitle: 'Quản lý trường học của bạn',
                      image: 'directors_role.png',
                      onTap: () async {
                        await ProfileService()
                            .getProfilesByRole(['Executive', 'Teacher']);
                        await AuthService()
                            .saveCurrentRoles(['Executive', 'Teacher']);
                        if (kIsWeb) {
                          GoRouter.of(context).go('/home/principal');
                        } else {
                          CustomPageTransition.navigateTo(
                              context: context,
                              page: const MainScreen(role: 'principal'),
                              transitionType:
                                  PageTransitionType.slideFromRight);
                        }
                      },
                    ),
                    const SizedBox(height: kMarginLg),
                    CustomSelectRoleItem(
                      title: 'Giáo viên',
                      subTitle: 'Tạo và quản lý lớp học của bạn',
                      image: 'teacher_role.png',
                      onTap: () async {
                        await ProfileService().getProfilesByRole(['Teacher']);
                        await AuthService().saveCurrentRoles(['Teacher']);
                        if (kIsWeb) {
                          GoRouter.of(context).go('/home/teacher');
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const MainScreen(role: 'teacher'),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: kMarginLg),
                    CustomSelectRoleItem(
                      title: 'Phụ huynh',
                      subTitle: 'Kết nối với các con của bạn',
                      image: 'parent_role.png',
                      onTap: () async {
                        await ProfileService().getProfilesByRole(['Parent']);
                        await AuthService().saveCurrentRoles(['Parent']);
                        if (kIsWeb) {
                          GoRouter.of(context).go('/home/parent');
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const MainScreen(role: 'parent'),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: kMarginLg),
                    CustomSelectRoleItem(
                      title: 'Học sinh',
                      subTitle: 'Tham gia học tập lớp học của bạn',
                      image: 'student_role.png',
                      onTap: () async {
                        await ProfileService().getProfilesByRole(['Student']);
                        await AuthService().saveCurrentRoles(['Student']);
                        if (kIsWeb) {
                          GoRouter.of(context).go('/home/student');
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const MainScreen(role: 'student'),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: kMarginXxl),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
