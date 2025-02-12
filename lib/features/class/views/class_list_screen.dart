import 'package:classpal_flutter_app/features/class/repository/class_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_avatar.dart';
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
        if (state is ClassPersonalFetchInProgress ||
            state is ClassSchoolFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ClassPersonalFetchFailure ||
            state is ClassSchoolFetchFailure) {
          // return _buildErrorView(state.error);
        }

        if (state is ClassSchoolFetchSuccess) {
          classes = state.classes;
        } else if (state is ClassPersonalFetchSuccess) {
          classes = state.classes;
          profiles = state.profiles;
        }

        if (classes.isEmpty) {
          return _buildEmptyClassView();
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
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      shrinkWrap: true,
      itemCount: classes.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: kMarginMd);
        } else if (index == classes.length + 1) {
          return const SizedBox(height: kMarginMd);
        } else {
          final currentClass = classes[index - 1];
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
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: kMarginLg),
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

  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Text(
        errorMessage,
        style: AppTextStyle.medium(kTextSizeLg),
      ),
    );
  }
}
