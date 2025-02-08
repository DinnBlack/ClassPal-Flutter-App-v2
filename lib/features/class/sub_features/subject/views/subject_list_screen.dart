import 'package:classpal_flutter_app/features/class/sub_features/subject/views/subject_create_screen.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/views/widgets/custom_subject_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../../../core/widgets/custom_page_transition.dart';
import '../bloc/subject_bloc.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SubjectBloc>().add(SubjectFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: BlocConsumer<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectFetchInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }
        },
        builder: (context, state) {
          if (state is SubjectFetchFailure) {
            return Center(
              child: Text('Error: ${state.error}'),
            );
          } else if (state is SubjectFetchSuccess) {
            if (state.subjects.isEmpty) {
              return _buildEmptySubjectView();
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                double itemHeight = 105;
                double itemWidth = (constraints.maxWidth - 20) / 2;
                return GridView.builder(
                  padding: const EdgeInsets.only(top: kPaddingMd),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: kMarginLg,
                    mainAxisSpacing: kMarginLg,
                    childAspectRatio: itemWidth / itemHeight,
                  ),
                  itemCount: state.subjects.length + 1,
                  itemBuilder: (context, index) {
                    if (index == state.subjects.length) {
                      return const CustomSubjectListItem(isAddButton: true);
                    }
                    final subject = state.subjects[index];
                    return CustomSubjectListItem(
                      subject: subject,
                    );
                  },
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildEmptySubjectView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/subject.jpg',
              height: 240,
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Thêm môn học mới nào!',
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
              text: 'Thêm môn học',
              onTap: () {
                CustomPageTransition.navigateTo(
                  context: context,
                  page: const SubjectCreateScreen(),
                  transitionType: PageTransitionType.slideFromRight,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
