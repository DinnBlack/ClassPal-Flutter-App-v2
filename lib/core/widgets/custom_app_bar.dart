import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../utils/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final Widget? bottomWidget;
  final double additionalHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leftWidget,
    this.rightWidget,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.bottomWidget,
    this.additionalHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: backgroundColor ?? kPrimaryColor,
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Row(
                children: [
                  // Left Widget
                  if (leftWidget != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: leftWidget,
                    ),
                  ],
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: titleStyle ?? AppTextStyle.semibold(kTextSizeLg),
                            ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: subtitleStyle ?? AppTextStyle.medium(kTextSizeXs),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Right Widget
                  if (rightWidget != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: rightWidget,
                    ),
                  ],
                ],
              ),
            ),

            if (bottomWidget != null) ...[
              bottomWidget!,
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    double bottomHeight = bottomWidget == null ? 0 : additionalHeight;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}