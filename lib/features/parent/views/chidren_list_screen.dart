import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/features/parent/bloc/parent_bloc.dart';

import '../../student/views/student_report_screen.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  State<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(ParentFetchChildrenStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ParentBloc, ParentState>(
      listener: (context, state) {
        if (state is ParentFetchChildrenInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }
      },
      child: BlocBuilder<ParentBloc, ParentState>(
        builder: (context, state) {
          if (state is ParentFetchChildrenInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ParentFetchChildrenFailure) {
            return Center(child: Text('Lỗi: ${state.error}'));
          } else if (state is ParentFetchChildrenSuccess) {
            final List<ProfileModel> children = state.children;
            if (children.isEmpty) {
              return _buildEmptyChildView();
            }

            return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                height: kMarginMd,
              ),
              padding: const EdgeInsets.all(kPaddingMd),
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return _CustomChildrenListItem(child: child);
              },
            );
          }
          return const Center(child: Text('Hãy tải danh sách con'));
        },
      ),
    );
  }


  Widget _buildEmptyChildView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/empty_student.png',
              height: 200,
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Chưa có con của bạn!',
              style: AppTextStyle.bold(kTextSizeLg),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kMarginSm),
            Text(
              'Liên hệ giáo viên để cùng tham gia vào lớp học và quản lý học tập của con bạn nhé',
              style: AppTextStyle.medium(kTextSizeXs),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomChildrenListItem extends StatelessWidget {
  const _CustomChildrenListItem({
    super.key,
    required this.child,
  });

  final ProfileModel child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: kGreyLightColor,
          borderRadius: BorderRadius.circular(kBorderRadiusMd)),
      child: Container(
        padding: const EdgeInsets.all(kPaddingMd),
        decoration: BoxDecoration(
          border: Border.all(
            color: kGreyMediumColor,
            width: 2,
          ),
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kBorderRadiusMd),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  backgroundImage: child.avatarUrl.isNotEmpty
                      ? NetworkImage(child.avatarUrl)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(
                  width: kMarginMd,
                ),
                Text(
                  child.displayName,
                  style: AppTextStyle.medium(kTextSizeMd),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginMd,
            ),
            CustomButton(
              text: 'Xem báo cáo',
              onTap: () async {
                await ProfileService().saveCurrentProfile(child);
                CustomPageTransition.navigateTo(
                    context: context,
                    page: StudentReportScreen(
                      studentId: child.id,
                    ),
                    transitionType: PageTransitionType.slideFromBottom);
              },
            ),
          ],
        ),
      ),
    );
  }
}
