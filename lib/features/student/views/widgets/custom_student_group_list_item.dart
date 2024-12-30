import 'package:flutter/material.dart';
import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';
import '../../models/student_group_model.dart';
import '../../models/student_model.dart';

class CustomStudentGroupListItem extends StatefulWidget {
  final StudentGroupModel? group;
  final bool? addItem;

  const CustomStudentGroupListItem({
    super.key,
    this.group,
    this.addItem = false,
  });

  @override
  State<CustomStudentGroupListItem> createState() =>
      _CustomStudentGroupListItemState();
}

class _CustomStudentGroupListItemState extends State<CustomStudentGroupListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

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
    List<StudentModel> studentIds = widget.group?.students ?? [];
    int studentCount = studentIds.length;

    List<Widget> studentAvatars = [];
    double offset = 0.0;

    for (int i = 0; i < studentCount && i < 3; i++) {
      StudentModel student = studentIds[i];
      Widget avatarImage;
      if (student.avatar != null) {
        avatarImage = CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(student.avatar!),
          backgroundColor: kPrimaryColor,
        );
      } else {
        avatarImage = CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(
            student.gender == "Male"
                ? 'assets/images/boy.jpg'
                : 'assets/images/girl.jpg',
          ),
          backgroundColor: kPrimaryColor,
        );
      }

      if (studentCount == 1) {
        offset = 0.0;
      } else if (studentCount == 2) {
        offset = (i == 0) ? -15.0 : 15.0;
      } else if (studentCount >= 3) {
        offset = (i == 0)
            ? -30.0
            : (i == 1)
                ? 0.0
                : 30.0;
      }

      studentAvatars.add(
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: kPrimaryColor,
                  width: 1, // Độ dày viền
                ),
              ),
              child: avatarImage,
            ),
          ),
        ),
      );
    }

    if (studentCount > 3) {
      studentAvatars.add(
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: const Offset(30.0, 0),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: kPrimaryColor,
              child: Text(
                '+${studentCount - 2}',
                style: AppTextStyle.semibold(kTextSizeXs, Colors.white),
              ),
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        _controller.forward();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(children: [
          Container(
            height: 105,
            decoration: BoxDecoration(
              color: kGreyLightColor,
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
            ),
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              border: Border.all(color: kGreyMediumColor, width: 2),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.addItem!)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kWhiteColor,
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: kPrimaryColor,
                      ),
                    )
                  else
                    Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: studentAvatars,
                      ),
                    ),
                  const SizedBox(height: kMarginSm),
                  Text(
                    widget.addItem!
                        ? "Thêm mới"
                        : widget.group?.groupName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.semibold(
                      kTextSizeXs,
                      widget.addItem! ? kPrimaryColor : kBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
