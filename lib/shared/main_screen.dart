import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/config/app_constants.dart';
import '../core/utils/app_text_style.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_avatar.dart';
import '../core/widgets/custom_list_item.dart';
import '../core/widgets/custom_loading_dialog.dart';
import '../features/auth/bloc/auth_bloc.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
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
        view = const ParentView();
        break;
      default:
        view = PrincipalView(user: user!);
        break;
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is AuthLogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng xuất thành công')),
          );
        } else if (state is AuthLogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng xuất thất bại')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: _buildAppBar(),
        body: view,
      ),
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
              imageUrl: user!.avatarUrl,
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
                        context
                            .read<AuthBloc>()
                            .add(AuthLogoutStarted(context: context));
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
