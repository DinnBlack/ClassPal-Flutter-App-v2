import 'package:classpal_flutter_app/core/utils/responsive.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';

class CustomStudentListItem extends StatefulWidget {
  final ProfileModel? student;
  final bool? addItem;
  final VoidCallback? onTap;
  final bool isPicker;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool isGroup;

  const CustomStudentListItem({
    super.key,
    this.student,
    this.addItem = false,
    this.onTap,
    this.isPicker = false,
    this.isSelected = false,
    this.onSelectionChanged,  this.isGroup = false,
  });

  @override
  State<CustomStudentListItem> createState() => _CustomStudentListItemState();
}

class _CustomStudentListItemState extends State<CustomStudentListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
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

  void _toggleSelection() {
    if (widget.isPicker) {
      setState(() {
        isSelected = !isSelected;
      });
      widget.onSelectionChanged?.call(isSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        await _controller.forward();

        widget.onTap?.call();
        _toggleSelection();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Responsive.isMobile(context)
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusMd),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        (widget.addItem ?? false)
                            ? Container(
                                width: 60,
                                height: 60,
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
                              )
                            : CircleAvatar(
                                backgroundColor: kGreyMediumColor,
                                backgroundImage: widget.student?.avatarUrl !=
                                        null
                                    ? NetworkImage(widget.student!.avatarUrl)
                                    : AssetImage(
                                        (widget.student?.displayName ?? '') ==
                                                'Male'
                                            ? 'assets/images/boy.jpg'
                                            : 'assets/images/girl.jpg',
                                      ) as ImageProvider,
                                radius: 30,
                                onBackgroundImageError: (_, __) {},
                              ),
                        if (widget.isPicker && isSelected)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: kMarginSm),
                    Container(
                      height: 34,
                      alignment: Alignment.center,
                      child: Text(
                        (widget.addItem ?? false)
                            ? "Thêm mới"
                            : widget.student?.displayName ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.bold(
                          kTextSizeXxs,
                          (widget.addItem ?? false)
                              ? kPrimaryColor
                              : kBlackColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : widget.isPicker || widget.isGroup
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusMd),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            (widget.addItem ?? false)
                                ? Container(
                                    width: 60,
                                    height: 60,
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
                                  )
                                : CircleAvatar(
                                    backgroundColor: kGreyMediumColor,
                                    backgroundImage:
                                        widget.student?.avatarUrl != null
                                            ? NetworkImage(
                                                widget.student!.avatarUrl)
                                            : AssetImage(
                                                (widget.student?.displayName ??
                                                            '') ==
                                                        'Male'
                                                    ? 'assets/images/boy.jpg'
                                                    : 'assets/images/girl.jpg',
                                              ) as ImageProvider,
                                    radius: 30,
                                    onBackgroundImageError: (_, __) {},
                                  ),
                            if (widget.isPicker && isSelected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: kMarginSm),
                        Container(
                          height: 34,
                          alignment: Alignment.center,
                          child: Text(
                            (widget.addItem ?? false)
                                ? "Thêm mới"
                                : widget.student?.displayName ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bold(
                              kTextSizeXxs,
                              (widget.addItem ?? false)
                                  ? kPrimaryColor
                                  : kBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kBorderRadiusLg),
                          color: kGreyLightColor,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(kBorderRadiusLg),
                            color: kWhiteColor,
                            border:
                                Border.all(width: 2, color: kGreyLightColor),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: kMarginMd,
                              ),
                              (widget.addItem ?? false)
                                  ? Container(
                                      width: 60,
                                      height: 60,
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
                                    )
                                  : CircleAvatar(
                                      backgroundColor: kGreyMediumColor,
                                      backgroundImage:
                                          widget.student?.avatarUrl != null
                                              ? NetworkImage(
                                                  widget.student!.avatarUrl)
                                              : AssetImage(
                                                  (widget.student?.displayName ??
                                                              '') ==
                                                          'Male'
                                                      ? 'assets/images/boy.jpg'
                                                      : 'assets/images/girl.jpg',
                                                ) as ImageProvider,
                                      radius: 30,
                                      onBackgroundImageError: (_, __) {},
                                    ),
                              const SizedBox(
                                width: kMarginMd,
                              ),
                              Expanded(
                                child: Container(
                                  height:
                                      Responsive.isMobile(context) ? 34 : null,
                                  alignment: Alignment.center,
                                  child: Text(
                                    (widget.addItem ?? false)
                                        ? "Thêm mới"
                                        : widget.student?.displayName ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: AppTextStyle.bold(
                                      Responsive.isMobile(context)
                                          ? kTextSizeXxs
                                          : kTextSizeSm,
                                      (widget.addItem ?? false)
                                          ? kPrimaryColor
                                          : kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: kMarginMd,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.isPicker && isSelected)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
      ),
    );
  }
}
