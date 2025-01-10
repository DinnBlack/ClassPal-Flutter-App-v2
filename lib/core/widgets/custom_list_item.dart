import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../config/app_constants.dart';
import '../utils/app_text_style.dart';

class CustomListItem extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool? hasTrailingArrow; // Thêm trường mới

  const CustomListItem({
    Key? key,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.leading,
    this.trailing,
    this.onTap,
    this.hasTrailingArrow, // Gán trường mới
  }) : super(key: key);

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.95,
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
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: kMarginMd),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.title != null)
                      Text(
                        widget.title!,
                        style: widget.titleStyle ??
                            AppTextStyle.semibold(kTextSizeSm),
                      ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        style: widget.subtitleStyle ??
                            AppTextStyle.medium(kTextSizeXs, kGreyColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null || widget.hasTrailingArrow == true) ...[
                const SizedBox(width: kMarginMd),
                widget.trailing ??
                    const Icon(
                      FontAwesomeIcons.chevronRight,
                      size: 14,
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
