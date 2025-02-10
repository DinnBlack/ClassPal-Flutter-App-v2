import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/features/auth/models/user_model.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utils/app_text_style.dart';
import '../../core/widgets/custom_list_item.dart';
import '../../core/widgets/custom_page_transition.dart';
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
  final classService = ClassService();
  final profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SchoolBloc>().add(SchoolFetchStarted());
      context.read<ClassBloc>().add(ClassPersonalFetchStarted());
    });
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
                    return CustomListItem(
                      title: 'Chưa tham gia trường học nào!',
                      subtitle: 'Tham gia trường học của bạn',
                      leading: const CustomAvatar(
                        imageAsset: 'assets/images/school.jpg',
                      ),
                      onTap: () {
                        CustomPageTransition.navigateTo(
                            context: context,
                            page: const ClassCreateScreen(),
                            transitionType: PageTransitionType.slideFromBottom);
                      },
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < schools.length; i++) ...[
                        CustomListItem(
                          title: schools[i].name,
                          subtitle: schools[i].address,
                          hasTrailingArrow: true,
                          leading: const CustomAvatar(
                            imageAsset: 'assets/images/school.jpg',
                          ),
                          onTap: () {
                            CustomPageTransition.navigateTo(
                                context: context,
                                page: SchoolScreen(
                                  school: schools[i],
                                ),
                                transitionType:
                                    PageTransitionType.slideFromRight);
                          },
                        ),
                        if (i != schools.length - 1)
                          const SizedBox(
                            height: kMarginLg,
                          ),
                      ],
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
            const SizedBox(
              height: kMarginLg,
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
                if (state is ClassPersonalFetchInProgress) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ClassPersonalFetchSuccess) {
                  final classes = state.classes;
                  final profiles = state.profiles;
                  if (classes.isEmpty) {
                    return CustomListItem(
                      title: 'Chưa có lớp học cá nhân nào!',
                      subtitle: 'Tạo lớp mới của bạn',
                      leading: const CustomAvatar(
                        imageAsset: 'assets/images/class.jpg',
                      ),
                      onTap: () {
                        CustomPageTransition.navigateTo(
                            context: context,
                            page: const ClassCreateScreen(),
                            transitionType: PageTransitionType.slideFromBottom);
                      },
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < classes.length; i++) ...[
                        CustomListItem(
                          title: classes[i].name,
                          hasTrailingArrow: true,
                          leading: const CustomAvatar(
                            imageAsset: 'assets/images/class.jpg',
                          ),
                          onTap: () async {
                            await classService
                                .saveClassToSharedPreferences(classes[i]);
                            await profileService
                                .saveProfileToSharedPreferences(profiles[i]);

                            print(await profileService
                                .getProfileFromSharedPreferences());

                            CustomPageTransition.navigateTo(
                                context: context,
                                page: ClassScreen(
                                  currentClass: classes[i],
                                ),
                                transitionType:
                                    PageTransitionType.slideFromRight);
                          },
                        ),
                        if (i != classes.length - 1)
                          const SizedBox(
                            height: kMarginLg,
                          ),
                      ]
                    ],
                  );
                }
                if (state is ClassPersonalFetchFailure) {
                  return CustomListItem(
                    title: 'Chưa có lớp học cá nhân nào!',
                    subtitle: 'Tạo lớp mới của bạn',
                    leading: const CustomAvatar(
                      imageAsset: 'assets/images/class.jpg',
                    ),
                    onTap: () {
                      CustomPageTransition.navigateTo(
                          context: context,
                          page: const ClassCreateScreen(),
                          transitionType: PageTransitionType.slideFromBottom);
                    },
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
