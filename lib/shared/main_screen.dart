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
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
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
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                              shape: BoxShape.circle,
                            ),
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
      leftWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomAvatar(
            user: widget.user,
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
    );
  }
}
