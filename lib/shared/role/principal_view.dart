import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_text_style.dart';
import '../../core/widgets/custom_list_item.dart';
import '../../features/class/bloc/class_bloc.dart';
import '../../features/class/views/class_create_screen.dart';
import '../../features/class/views/class_screen.dart';
import '../../features/school/bloc/school_bloc.dart';

class PrincipalView extends StatefulWidget {
  static const route = 'PrincipalView';
  final UserModel user;

  const PrincipalView({
    super.key,
    required this.user,
  });

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(SchoolFetchStarted());
    context.read<ClassBloc>().add(ClassFetchByUserStarted(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
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
                if (state is SchoolFetchInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SchoolFetchSuccess) {
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
                if (state is SchoolFetchFailure) {
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
}
