import 'package:flutter/material.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';

class CustomSelectRoleItem extends StatefulWidget {
  final String title;
  final String subTitle;
  final String image;
  final VoidCallback? onTap;

  const CustomSelectRoleItem({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    this.onTap,
  });

  @override
  _CustomSelectRoleItemState createState() => _CustomSelectRoleItemState();
}

class _CustomSelectRoleItemState extends State<CustomSelectRoleItem>
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

        if (widget.onTap != null) {
          widget.onTap!();
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
                border: Border.all(width: 2, color: kGreyMediumColor),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/${widget.image}'),
                  const SizedBox(
                    width: kMarginMd,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.title,
                          style: AppTextStyle.semibold(kTextSizeLg)),
                      Text(widget.subTitle,
                          style: AppTextStyle.medium(kTextSizeXs)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
