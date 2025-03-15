import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item_skeleton.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
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
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../../student/views/student_report_screen.dart';
import '../bloc/class_bloc.dart';
import '../models/class_model.dart';
import 'class_create_screen.dart';
import 'class_screen.dart';

class ClassListScreen extends StatefulWidget {
  final bool isClassSchoolView;
  final bool isParentView;
  final bool isStudentView;

  const ClassListScreen({
    super.key,
    this.isClassSchoolView = false,
    this.isParentView = false,
    this.isStudentView = false,
  });

  @override
  State<ClassListScreen> createState() => _ClassListScreenState();
}

class _ClassListScreenState extends State<ClassListScreen> {
  late List<ClassModel> classes = [];
  late List<ProfileModel> profiles = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isClassSchoolView) {
      context.read<ClassBloc>().add(ClassSchoolFetchStarted());
    } else {
      context.read<ClassBloc>().add(ClassPersonalFetchStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClassBloc, ClassState>(
      builder: (context, state) {
        if (state is ClassPersonalFetchInProgress) {
          return _buildSkeletonLoading();
        }
        if (state is ClassSchoolFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ClassSchoolFetchSuccess) {
          classes = state.classes;
        } else if (state is ClassPersonalFetchSuccess) {
          classes = state.classes;
          profiles = state.profiles;
        }

        if (classes.isEmpty) {
          if (widget.isClassSchoolView) {
            return _buildEmptyClassSchoolView();
          } else {
            return _buildEmptyClassView();
          }
        } else if (widget.isStudentView) {
          return _buildListClassStudentView();
        } else if (widget.isClassSchoolView) {
          return _buildListClassSchoolView();
        } else {
          return _buildListClassPersonalView();
        }
      },
    );
  }

  Widget _buildSkeletonLoading() {
    return FutureBuilder<List<ProfileModel>>(
      future: ProfileService().getUserProfiles(),
      builder: (context, snapshot) {
        int itemCount = 2;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          itemCount =
              snapshot.data!.where((profile) => profile.groupType == 1).length;
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
                  height: 200,
                  width: 200,
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
                        width: 80,
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

  Widget _buildListClassPersonalView() {
    return Responsive.isMobile(context)
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classes.length + 1,
            // Thêm 1 item cho lớp học mới
            itemBuilder: (context, index) {
              if (index == classes.length) {
                // Hiển thị item tạo lớp học mới
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
                  title: 'Tạo lớp học mới',
                  subtitle: 'Quản lý các lớp học cá nhân của bạn',
                  onTap: () async {
                    if (kIsWeb) {
                      GoRouter.of(context).go('/home/class/create');
                    } else {
                      CustomPageTransition.navigateTo(
                        context: context,
                        page: const ClassCreateScreen(),
                        transitionType: PageTransitionType.slideFromRight,
                      );
                    }
                  },
                );
              }
              final currentClass = classes[index];
              final profile = profiles[index];

              return CustomListItem(
                leading: const CustomAvatar(
                  imageAsset: 'assets/images/class.jpg',
                ),
                title: currentClass.name,
                onTap: () async {
                  await ProfileService().saveCurrentProfile(profile);
                  await ClassService().saveCurrentClass(currentClass);
                  if (kIsWeb) {
                    GoRouter.of(context).go(
                      '/home/class/detail/${currentClass.id}',
                      extra: {
                        'currentClass': currentClass.toMap()
                      },
                    );
                  } else {
                    CustomPageTransition.navigateTo(
                      context: context,
                      page: ClassScreen(currentClass: currentClass),
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
            itemCount: classes.length + 1,
            // Thêm 1 item cho lớp học mới
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isTablet(context) ? 4 : 6,
              crossAxisSpacing: kPaddingLg,
              mainAxisSpacing: kPaddingLg,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              if (index == classes.length) {
                // Hiển thị item tạo lớp học mới
                return _buildCreateClassItem();
              }
              final currentClass = classes[index];
              final profile = profiles[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await ProfileService().saveCurrentProfile(profile);
                    await ClassService().saveCurrentClass(currentClass);
                    if (kIsWeb) {
                      GoRouter.of(context).go(
                        '/home/class/detail/${currentClass.id}',
                        extra: {
                          'currentClass': currentClass.toMap()
                        },
                      );
                    } else {
                      CustomPageTransition.navigateTo(
                        context: context,
                        page: ClassScreen(currentClass: currentClass),
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
                          Text(
                            currentClass.name,
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
  }

  /// Widget hiển thị item "Lớp học mới"
  Widget _buildCreateClassItem() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (kIsWeb) {
            GoRouter.of(context).go('/home/class/create');
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: const ClassCreateScreen(),
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
                  'Lớp học mới',
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

  Widget _buildListClassSchoolView() {
    return Responsive.isMobile(context)
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final currentClass = classes[index];

              return CustomListItem(
                leading: const CustomAvatar(
                  imageAsset: 'assets/images/class.jpg',
                ),
                title: currentClass.name,
                onTap: () async {
                  await ClassService().saveCurrentClass(currentClass);
                  if (kIsWeb) {
                    GoRouter.of(context).push(
                      '/home/class/detail/${currentClass.id}',
                      extra: {
                        'currentClass': currentClass.toMap()
                      },
                    );
                  } else {
                    CustomPageTransition.navigateTo(
                      context: context,
                      page: ClassScreen(currentClass: currentClass),
                      transitionType: PageTransitionType.slideFromRight,
                    );
                  }
                },
                hasTrailingArrow: true,
              );
            },
            separatorBuilder: (context, index) =>
                const SizedBox(height: kMarginMd),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: classes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isTablet(context) ? 4 : 6,
              crossAxisSpacing: kPaddingLg,
              mainAxisSpacing: kPaddingLg,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final currentClass = classes[index];

              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    await ClassService().saveCurrentClass(currentClass);
                    if (kIsWeb) {
                      final profile = await ProfileService().getCurrentProfile();
                      GoRouter.of(context).go(
                        '/home/school/detail/${profile!.groupId}/class/detail/${currentClass.id}',
                        extra: {
                          'currentClass': currentClass.toMap()
                        },
                      );
                    } else {
                      CustomPageTransition.navigateTo(
                        context: context,
                        page: ClassScreen(currentClass: currentClass),
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
                          Text(
                            currentClass.name,
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
  }

  Widget _buildListClassStudentView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final currentClass = classes[index];
        final profile = profiles[index];
        return Container(
          padding: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              color: kGreyLightColor),
          child: Container(
            padding: const EdgeInsets.all(kPaddingMd),
            decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
                border: Border.all(width: 2, color: kGreyLightColor)),
            child: Column(
              children: [
                CustomListItem(
                  onTap: () async {},
                  title: currentClass.name,
                  leading: const CustomAvatar(
                    imageAsset: 'assets/images/class.jpg',
                  ),
                  hasTrailingArrow: true,
                ),
                const SizedBox(
                  height: kMarginMd,
                ),
                CustomButton(
                  text: 'Xem báo cáo',
                  onTap: () async {
                    await ProfileService().saveCurrentProfile(profile);
                    await ClassService().saveCurrentClass(currentClass);

                    if (kIsWeb) {
                      showCustomDialog(
                        context,
                        StudentReportScreen(
                          studentId: profile.id,
                        ),
                      );
                    } else {
                      CustomPageTransition.navigateTo(
                          context: context,
                          page: StudentReportScreen(
                            studentId: profile.id,
                          ),
                          transitionType: PageTransitionType.slideFromBottom);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }

  Widget _buildEmptyClassView() {
    return Responsive.isMobile(context)
        ? CustomListItem(
            title: 'Chưa có lớp học cá nhân nào!',
            subtitle: 'Tạo lớp học cá nhân của bạn nào',
            hasTrailingArrow: true,
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
                size: 20,
              ),
            ),
            onTap: () async {
              if (kIsWeb) {
                GoRouter.of(context).go('/home/class/create');
              } else {
                CustomPageTransition.navigateTo(
                  context: context,
                  page: const ClassCreateScreen(),
                  transitionType: PageTransitionType.slideFromRight,
                );
              }
            },
          )
        : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                if (kIsWeb) {
                  GoRouter.of(context).go('/home/class/create');
                } else {
                  CustomPageTransition.navigateTo(
                    context: context,
                    page: const ClassCreateScreen(),
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
                        'Lớp học mới',
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
  }

  Widget _buildEmptyClassSchoolView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty_class.jpg', height: 200),
          const SizedBox(height: kMarginLg),
          Text(
            'Thêm lớp học mới nào!',
            style: AppTextStyle.bold(kTextSizeMd),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kMarginSm),
          Text(
            'Khiến học sinh thu hút với phản hồi tức thời và bắt đầu xây dựng cộng đồng lớp học của mình nào',
            style: AppTextStyle.medium(kTextSizeXs),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Thêm lớp học',
            onTap: () {
              CustomPageTransition.navigateTo(
                context: context,
                page: const ClassCreateScreen(
                  isClassSchoolCreateView: true,
                ),
                transitionType: PageTransitionType.slideFromBottom,
              );
            },
          ),
        ],
      ),
    );
  }
}
