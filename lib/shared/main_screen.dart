import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/app_text_style.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_list_item.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/class/bloc/class_bloc.dart';
import '../features/class/views/class_create_screen.dart';
import '../features/class/views/class_screen.dart';
import '../features/school/bloc/school_bloc.dart';

class MainScreen extends StatefulWidget {
  static const route = 'MainScreen';
  final UserModel user;
  final String role;

  const MainScreen({
    super.key,
    required this.user,
    required this.role,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(SchoolFetchByUserStarted(user: widget.user));
    context.read<ClassBloc>().add(ClassFetchByUserStarted(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: kMarginLg,
            ),
            Text(
              'Trường học',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            BlocBuilder<SchoolBloc, SchoolState>(
              builder: (context, state) {
                if (state is SchoolFetchByUserInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SchoolFetchByUserSuccess) {
                  final schools = state.schools;
                  if (schools.isEmpty) {
                    return Center(
                      child: Text(
                        'Chưa tham gia trường học nào!',
                        style: AppTextStyle.semibold(kTextSizeMd),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var school in schools) ...[
                        CustomListItem(
                          title: school.name,
                          subtitle: school.address,
                          hasTrailingArrow: true,
                          leading: const CustomAvatar(
                            imageAsset: 'assets/images/school.jpg',
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, SchoolScreen.route,
                                arguments: {'school': school});
                          },
                        ),
                        const SizedBox(
                          height: kMarginLg,
                        ),
                      ]
                    ],
                  );
                }
                if (state is SchoolFetchByUserFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: AppTextStyle.semibold(kTextSizeMd),
                    ),
                  );
                }
                return Container();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lớp học cá nhân',
                  style: AppTextStyle.semibold(kTextSizeMd),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ClassCreateScreen.route,
                    );
                  },
                  child: Text(
                    '+ Thêm lớp học',
                    style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            BlocBuilder<ClassBloc, ClassState>(
              builder: (context, state) {
                if (state is ClassFetchByUserInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ClassFetchByUserSuccess) {
                  final classes = state.classes;
                  if (classes.isEmpty) {
                    return Center(
                      child: Text(
                        'Chưa có lớp học cá nhân nào!',
                        style: AppTextStyle.semibold(kTextSizeMd),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      for (var currentClass in classes) ...[
                        CustomListItem(
                          title: currentClass.name,
                          hasTrailingArrow: true,
                          leading: const CustomAvatar(
                            imageAsset: 'assets/images/class.jpg',
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, ClassScreen.route,
                                arguments: {'currentClass': currentClass});
                          },
                        ),
                        const SizedBox(
                          height: kMarginLg,
                        ),
                      ]
                    ],
                  );
                }
                if (state is ClassFetchByUserFailure) {
                  return Center(
                    child: Text(
                      state.error,
                      style: AppTextStyle.semibold(kTextSizeMd),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
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
              profile: widget.user,
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
                        context.read<AuthBloc>().add(AuthLogoutStarted(context: context));
                      },
                      child: Text(
                        'Đăng xuất',
                        style:
                        AppTextStyle.bold(kTextSizeSm, kPrimaryColor),
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
                    title: widget.user.name,
                    subtitle: widget.role,
                    leading: CustomAvatar(
                      profile: widget.user,
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: kPaddingLg),
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
                        style: AppTextStyle.regular(
                            kTextSizeSm, kPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ),const SizedBox(height: kMarginXl),
            ],
          ),
        );
      },
    );
  }
}
