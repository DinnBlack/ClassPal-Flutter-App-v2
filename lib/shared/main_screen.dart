import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/class/views/class_join_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/utils/app_text_style.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/custom_list_item.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(
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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
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
                          const SizedBox(
                            height: kMarginLg,
                          ),
                          CustomListItem(
                            title: school.name,
                            subtitle: school.address,
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, SchoolScreen.route, arguments: {'school' : school});
                            },
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
              const SizedBox(
                height: kMarginXl,
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
              CustomListItem(
                title: 'Lớp toán nâng cao',
                subtitle: 'Giáo viên chính',
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: kRedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ClassScreen.route);
                },
              ),
              const SizedBox(
                height: kMarginLg,
              ),
              CustomListItem(
                title: 'Lớp hóa cơ bản',
                subtitle: 'Đồng giáo viên',
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: kPrimaryLightColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ClassScreen.route);
                },
              ),
              const SizedBox(
                height: kMarginLg,
              ),
              CustomListItem(
                title: 'Tham gia lớp học',
                subtitle: 'Nhận quyền truy cập các tính năng lớp học',
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: kGreyColor,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, ClassJoinScreen.route);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
