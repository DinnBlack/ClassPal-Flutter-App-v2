import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomListItem extends StatefulWidget {
  final String? title;
  final TextStyle? titleStyle;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  const CustomListItem({
    Key? key,
    this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
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

    // Gọi callback khi thả ngón tay
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: isPressed ? 0.95 : 1.0,
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
                      ),
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: kMarginMd),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
