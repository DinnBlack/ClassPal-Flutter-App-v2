import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:classpal_flutter_app/features/school/views/school_create_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_join_screen.dart';
import 'package:classpal_flutter_app/features/school/views/school_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_list_item_skeleton.dart';
import '../../../core/widgets/custom_page_transition.dart';
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
        } else if (widget.isTeacherView) {
          return _buildListSchoolTeacherView();
        } else {
          return _buildListSchoolView();
        }
      },
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
          itemCount = itemCount > 0 ? itemCount : 1;
        }

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
      },
    );
  }

  Widget _buildListSchoolView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];
        final profile = profiles[index];
        String classesText = school.name;

        return CustomListItem(
          leading: const CustomAvatar(
            imageAsset: 'assets/images/school.jpg',
          ),
          title: school.name,
          subtitle: classesText,
          onTap: () async {
            await ProfileService().saveCurrentProfile(profile);

            CustomPageTransition.navigateTo(
                context: context,
                page: SchoolScreen(
                  school: school,
                ),
                transitionType: PageTransitionType.slideFromRight);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }

  Widget _buildListSchoolTeacherView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];
        final profile = profiles[index];
        String classesText = school.name;

        return CustomListItem(
          leading: const CustomAvatar(
            imageAsset: 'assets/images/school.jpg',
          ),
          title: school.name,
          subtitle: classesText,
          onTap: () async {
            await ProfileService().saveCurrentProfile(profile);

            CustomPageTransition.navigateTo(
                context: context,
                page: SchoolScreen(
                  school: school,
                ),
                transitionType: PageTransitionType.slideFromRight);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }
}
