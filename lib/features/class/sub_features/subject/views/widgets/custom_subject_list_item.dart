import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/sub_features/grade/views/grade_student_create_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/config/app_constants.dart';
import '../../../../../../core/utils/app_text_style.dart';
import '../../models/subject_model.dart';
import '../subject_create_screen.dart';
import '../subject_detail_screen.dart';

class CustomSubjectListItem extends StatefulWidget {
  final bool isAddButton;
  final SubjectModel? subject;
  final bool isGradeStudentView;
  final String? studentId;

  const CustomSubjectListItem(
      {super.key,
      this.subject,
      this.isAddButton = false,
      this.isGradeStudentView = false,
      this.studentId});

  @override
  State<CustomSubjectListItem> createState() => _CustomSubjectListItemState();
}

class _CustomSubjectListItemState extends State<CustomSubjectListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.9,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 100),
    )..value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        await _controller.forward();

        if (widget.isAddButton) {
          if (kIsWeb) {
            showCustomDialog(context, const SubjectCreateScreen());
          } else {
            CustomPageTransition.navigateTo(
                context: context,
                page: const SubjectCreateScreen(),
                transitionType: PageTransitionType.slideFromRight);
          }
        } else if (widget.isGradeStudentView) {
          showCustomDialog(
            context,
            GradeStudentCreateScreen(
              subject: widget.subject!,
              studentId: widget.studentId,
            ),
            isDismissible: false,
            maxWidth: 400,
          );
        } else {
          if (kIsWeb) {
            showCustomDialog(
              context,
              SubjectDetailScreen(
                subject: widget.subject!,
              ),
            );
          } else {
            CustomPageTransition.navigateTo(
                context: context,
                page: SubjectDetailScreen(
                  subject: widget.subject!,
                ),
                transitionType: PageTransitionType.slideFromRight);
          }
        }
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(
          children: [
            Container(
              height: 105,
              decoration: BoxDecoration(
                color: kGreyLightColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
                border: Border.all(color: kGreyMediumColor, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: widget.isAddButton
                    ? [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kGreyColor,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: kMarginMd,
                        ),
                        Expanded(
                          child: Text('Thêm môn',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.semibold(
                                  kTextSizeSm, kPrimaryColor)),
                        ),
                      ]
                    : [
                        Image.network(
                          widget.subject!.avatarUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: kMarginMd,
                        ),
                        Expanded(
                          child: Text(
                            widget.subject!.name,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.semibold(kTextSizeSm),
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
