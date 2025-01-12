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
  final bool isSafeArea;
  final double horizontalPadding; // Thêm trường horizontalPadding

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
    this.isSafeArea = true,
    this.horizontalPadding = 0, // Giá trị mặc định là 0
  });

  @override
  Widget build(BuildContext context) {
    Widget appBarContent = Container(
      color: backgroundColor ?? kTransparentColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding), // Áp dụng horizontalPadding
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight,
              child: Stack(
                children: [
                  // Left Widget
                  if (leftWidget != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: kPaddingMd),
                        child: leftWidget,
                      ),
                    ),
                  ],
                  Center(
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: kPaddingMd),
                        child: rightWidget,
                      ),
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

    // If SafeArea is enabled, wrap the content in SafeArea
    if (isSafeArea) {
      appBarContent = SafeArea(child: appBarContent);
    }

    return appBarContent;
  }

  @override
  Size get preferredSize {
    double bottomHeight = bottomWidget == null ? 0 : additionalHeight;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
