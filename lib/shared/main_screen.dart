import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:classpal_flutter_app/features/school/bloc/school_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/config/app_constants.dart';
import '../core/utils/app_text_style.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_avatar.dart';
import '../core/widgets/custom_list_item.dart';
import '../features/auth/models/user_model.dart';
import 'role/parent_view.dart';
import 'role/principal_view.dart';
import 'role/student_view.dart';
import 'role/teacher_view.dart';

class MainScreen extends StatefulWidget {
  static const route = 'MainScreen';
  final String role;

  const MainScreen({
    super.key,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
    print(user);
  }

  Future<void> _loadUser() async {
    UserModel? fetchedUser = await AuthService().getUserFromPrefs();
    if (mounted) {
      setState(() {
        user = fetchedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget view;

    switch (widget.role) {
      case 'principal':
        view = PrincipalView(user: user!);
        break;
      case 'teacher':
        view = TeacherView(user: user!);
        break;
      case 'student':
        view = StudentView(user: user!);
        break;
      case 'parent':
        view = ParentView(user: user!);
        break;
      default:
        view = PrincipalView(user: user!);
        break;
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: view,
    );
  }

  CustomAppBar _buildAppBar() {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'CLASSPAL',
      titleStyle: const TextStyle(
          fontFamily: 'ZenDots',
          color: kPrimaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      leftWidget: GestureDetector(
        onTap: () {
          _showTopSheet(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomAvatar(
              profile: user,
              size: 30,
            ),
            const SizedBox(
              width: kMarginSm,
            ),
            const Icon(
              FontAwesomeIcons.chevronDown,
              size: 16,
            )
          ],
        ),
      ),
    );
  }

  void _showTopSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: kWhiteColor,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(kMarginMd)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: kMarginMd),
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(kBorderRadiusMd),
                ),
              ),
              const SizedBox(height: kMarginMd),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đổi hồ sơ',
                      style: AppTextStyle.bold(kTextSizeLg),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<SchoolBloc>().add(SchoolCreateStarted(
                            name: 'School 3',
                            address: 'address 3',
                            phoneNumber: '0123123111'));
                      },
                      child: Text(
                        'Đăng xuất',
                        style: AppTextStyle.bold(kTextSizeSm, kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kMarginLg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
                child: Container(
                  padding: const EdgeInsets.all(kPaddingMd),
                  decoration: BoxDecoration(
                    color: kGreyLightColor,
                    borderRadius: BorderRadius.circular(kBorderRadiusXl),
                  ),
                  child: CustomListItem(
                    isAnimation: false,
                    title: user?.name ?? 'Người dùng',
                    leading: CustomAvatar(
                      profile: user,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: kMarginLg),
              const Divider(
                color: kGreyMediumColor,
                height: 2,
                thickness: 2,
                indent: kPaddingMd,
                endIndent: kPaddingMd,
              ),
              const SizedBox(height: kMarginLg),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.userPlus,
                        color: kPrimaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: kMarginMd),
                      Text(
                        'Đăng nhập vào tài khoản khác',
                        style: AppTextStyle.regular(kTextSizeSm, kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: kMarginXl),
            ],
          ),
        );
      },
    );
  }
}
