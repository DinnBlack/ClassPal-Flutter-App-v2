import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:classpal_flutter_app/features/school/repository/school_service.dart';
import 'package:classpal_flutter_app/features/school/views/school_create_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_join_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_list_item_skeleton.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../auth/models/role_model.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../bloc/school_bloc.dart';

class SchoolListScreen extends StatefulWidget {
  final bool isTeacherView;

  const SchoolListScreen({
    super.key,
    this.isTeacherView = false,
  });

  @override
  State<SchoolListScreen> createState() => _SchoolListScreenState();
}

class _SchoolListScreenState extends State<SchoolListScreen> {
  late List<SchoolModel> schools = [];
  late List<ProfileModel> profiles = [];

  @override
  void initState() {
    super.initState();
    context.read<SchoolBloc>().add(SchoolFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolBloc, SchoolState>(
      builder: (context, state) {
        if (state is SchoolFetchInProgress) {
          return _buildSkeletonLoading();
        } else if (state is SchoolFetchFailure) {
          return CustomListItem(
            title: 'Chưa tham gia trường học nào!',
            subtitle: 'Tham gia trường học của bạn',
            leading: const CustomAvatar(
              imageAsset: 'assets/images/school.jpg',
            ),
            onTap: () {
              CustomPageTransition.navigateTo(
                  context: context,
                  page: const SchoolJoinScreen(),
                  transitionType: PageTransitionType.slideFromBottom);
            },
          );
        }

        if (state is SchoolFetchSuccess) {
          schools = state.schools;
          profiles = state.profiles;
        }
        if (schools.isEmpty) {
          if (widget.isTeacherView) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  if (kIsWeb) {
                    GoRouter.of(context).go('/home/school/create');
                  } else {
                    CustomPageTransition.navigateTo(
                      context: context,
                      page: const SchoolCreateScreen(),
                      transitionType: PageTransitionType.slideFromRight,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: kGreyLightColor,
                    borderRadius: BorderRadius.circular(kBorderRadiusLg),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 200,
                    height: 200,
                    padding: const EdgeInsets.all(kPaddingMd),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kBorderRadiusLg),
                      border: Border.all(width: 2, color: kGreyLightColor),
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: kMarginMd),
                        Text(
                          widget.isTeacherView
                              ? 'Tham gia trường'
                              : 'Tạo trường học',
                          style:
                              AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return CustomListItem(
              title: 'Chưa tham gia trường học nào!',
              subtitle: 'Tham gia trường học của bạn',
              leading: const CustomAvatar(
                imageAsset: 'assets/images/school.jpg',
              ),
              onTap: () {
                CustomPageTransition.navigateTo(
                    context: context,
                    page: const SchoolCreateScreen(),
                    transitionType: PageTransitionType.slideFromBottom);
              },
            );
          }
        } else {
          return _buildListSchoolView();
        }
      },
    );
  }

  /// Widget hiển thị item "Lớp học mới"
  Widget _buildCreateSchoolItem() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (kIsWeb) {
            GoRouter.of(context).go('/home/school/create');
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const SchoolCreateScreen(),
              transitionType: PageTransitionType.slideFromRight,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: kGreyLightColor,
            borderRadius: BorderRadius.circular(kBorderRadiusLg),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(kPaddingMd),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(kBorderRadiusLg),
              border: Border.all(width: 2, color: kGreyLightColor),
            ),
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: kMarginMd),
                Text(
                  'Trường học mới',
                  style: AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return FutureBuilder<List<ProfileModel>>(
      future: ProfileService().getUserProfiles(),
      builder: (context, snapshot) {
        int itemCount = 1;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          itemCount =
              snapshot.data!.where((profile) => profile.groupType == 0).length;
          itemCount = itemCount > 0 ? itemCount + 1 : 1;
        }

        if (Responsive.isMobile(context)) {
          return ListView.separated(
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => const SkeletonLoader(
              builder: CustomListItemSkeleton(),
            ),
            separatorBuilder: (context, index) =>
                const SizedBox(height: kMarginMd),
          );
        } else {
          return GridView.builder(
            itemCount: itemCount,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isTablet(context) ? 4 : 6,
              crossAxisSpacing: kPaddingLg,
              mainAxisSpacing: kPaddingLg,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) => SkeletonLoader(
              builder: SizedBox(
                width: 200,
                height: 200,
                child: Container(
                  padding: const EdgeInsets.all(kPaddingMd),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: kGreyLightColor),
                    borderRadius: BorderRadius.circular(kBorderRadiusLg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/class.jpg',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: kMarginLg),
                      Container(
                        height: 20,
                        width: 100,
                        decoration: BoxDecoration(
                            color: kGreyLightColor,
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusLg)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildListSchoolView() {
    return FutureBuilder<List<RoleModel>>(
      future: AuthService().getRoles(),
      builder: (context, snapshot) {
        final userRoles = snapshot.data ?? [];

        return Responsive.isMobile(context)
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schools.length + 1,
                itemBuilder: (context, index) {
                  if (index == schools.length) {
                    return CustomListItem(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                            color: kPrimaryColor, shape: BoxShape.circle),
                        child: const Icon(
                          FontAwesomeIcons.plus,
                          color: kWhiteColor,
                        ),
                      ),
                      title: 'Tạo trường học mới',
                      subtitle: 'Quản lý trường học của bạn',
                      onTap: () async {
                        if (kIsWeb) {
                          GoRouter.of(context).go('/home/school/create');
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: const SchoolCreateScreen(),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                        CustomPageTransition.navigateTo(
                          context: context,
                          page: const SchoolCreateScreen(),
                          transitionType: PageTransitionType.slideFromRight,
                        );
                      },
                    );
                  }
                  final school = schools[index];
                  final profile = profiles[index];
                  final matchingRoles = userRoles
                      .where((role) => profile.roles.contains(role.id))
                      .map((role) => role.name)
                      .toList();
                  final classesText = matchingRoles.isNotEmpty
                      ? matchingRoles.join(', ')
                      : 'Không có vai trò';

                  return CustomListItem(
                    leading: const CustomAvatar(
                        imageAsset: 'assets/images/school.jpg'),
                    title: school.name,
                    subtitle: _getRoleDisplayName(classesText),
                    onTap: () async {
                      await ProfileService().saveCurrentProfile(profile);
                      await SchoolService().saveCurrentSchool(school, classesText == 'Executive' ? false : true);
                      if (kIsWeb) {
                        GoRouter.of(context).go(
                          '/home/school/${school.id}',
                          extra: {
                            'school': school.toMap(),
                            'isTeacherView':
                                classesText == 'Executive' ? false : true,
                          },
                        );
                      } else {
                        CustomPageTransition.navigateTo(
                          context: context,
                          page: SchoolScreen(
                            school: school,
                            isTeacherView:
                                classesText == 'Executive' ? false : true,
                          ),
                          transitionType: PageTransitionType.slideFromRight,
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: kMarginMd),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: schools.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isTablet(context) ? 4 : 6,
                  crossAxisSpacing: kPaddingLg,
                  mainAxisSpacing: kPaddingLg,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  if (index == schools.length) {
                    // Hiển thị item tạo lớp học mới
                    return _buildCreateSchoolItem();
                  }
                  final school = schools[index];
                  final profile = profiles[index];
                  final matchingRoles = userRoles
                      .where((role) => profile.roles.contains(role.id))
                      .map((role) => role.name)
                      .toList();
                  final classesText = matchingRoles.isNotEmpty
                      ? matchingRoles.join(', ')
                      : 'Không có vai trò';

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        await ProfileService().saveCurrentProfile(profile);
                        await SchoolService().saveCurrentSchool(school, classesText == 'Executive' ? false : true);
                        if (kIsWeb) {
                          GoRouter.of(context).go(
                            '/home/school/${school.id}',
                            extra: {
                              'school': school.toMap(),
                              'isTeacherView':
                                  classesText == 'Executive' ? false : true,
                            },
                          );
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: SchoolScreen(
                              school: school,
                              isTeacherView:
                                  classesText == 'Executive' ? false : true,
                            ),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: kGreyLightColor,
                          borderRadius: BorderRadius.circular(kBorderRadiusLg),
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(kPaddingMd),
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 2, color: kGreyLightColor),
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusLg),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/school.jpg',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: kMarginLg),
                              Text(
                                school.name,
                                style: AppTextStyle.semibold(kTextSizeMd),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  /// Hàm chuyển đổi tên vai trò sang dạng hiển thị tùy chỉnh
  String _getRoleDisplayName(String roleName) {
    switch (roleName) {
      case 'Executive':
        return 'Ban Giám Hiệu';
      case 'Student':
        return 'Học Sinh';
      case 'Teacher':
        return 'Giáo Viên';
      case 'Parent':
        return 'Phụ Huynh';
      default:
        return roleName; // Giữ nguyên nếu không nằm trong danh sách
    }
  }
}
