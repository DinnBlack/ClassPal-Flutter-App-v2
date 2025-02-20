import 'package:classpal_flutter_app/core/widgets/custom_list_item_skeleton.dart';
import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_page_transition.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../bloc/class_bloc.dart';
import '../models/class_model.dart';
import 'class_create_screen.dart';
import 'class_screen.dart';

class ClassListScreen extends StatefulWidget {
  final bool isClassSchoolView;

  const ClassListScreen({
    super.key,
    this.isClassSchoolView = false,
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
        } else if (widget.isClassSchoolView) {
          return _buildListClassSchoolView();
        } else {
          return _buildListClassPersonalView();
        }
      },
    );
  }

  Widget _buildListClassPersonalView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final currentClass = classes[index];
        final profile = profiles[index];
        String classesText = currentClass.name;

        return CustomListItem(
          leading: const CustomAvatar(
            imageAsset: 'assets/images/class.jpg',
          ),
          title: currentClass.name,
          subtitle: classesText,
          onTap: () async {
            await ProfileService().saveCurrentProfile(profile);
            await ClassService().saveCurrentClass(currentClass);
            CustomPageTransition.navigateTo(
                context: context,
                page: ClassScreen(
                  currentClass: currentClass,
                ),
                transitionType: PageTransitionType.slideFromRight);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
    );
  }

  Widget _buildListClassSchoolView() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final currentClass = classes[index];
        return CustomListItem(
          onTap: () async {
            await ClassService().saveCurrentClass(currentClass);
            CustomPageTransition.navigateTo(
                context: context,
                page: ClassScreen(
                  currentClass: currentClass,
                ),
                transitionType: PageTransitionType.slideFromRight);
          },
          title: currentClass.name,
          leading: const CustomAvatar(
            imageAsset: 'assets/images/class.jpg',
          ),
          hasTrailingArrow: true,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginMd),
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
              snapshot.data!.where((profile) => profile.groupType == 1).length;
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

  Widget _buildEmptyClassView() {
    return CustomListItem(
      title: 'Chưa có lớp học cá nhân nào!',
      subtitle: 'Tạo lớp học cá nhân của bạn nào',
      hasTrailingArrow: true,
      leading: const CustomAvatar(
        imageAsset: 'assets/images/class.jpg',
      ),
      onTap: () async {
        CustomPageTransition.navigateTo(
            context: context,
            page: const ClassCreateScreen(),
            transitionType: PageTransitionType.slideFromRight);
      },
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
            style: AppTextStyle.bold(kTextSizeLg),
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
