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

class _CustomSelectRoleItemState extends State<CustomSelectRoleItem> {
  bool isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });

    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: isPressed ? 0.95 : 1.0,
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
