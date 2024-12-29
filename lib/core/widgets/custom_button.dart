import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart';

class CustomButton extends StatefulWidget {
  final double? height;
  final String? text;
  final VoidCallback? onTap;
  final bool isValid;

  const CustomButton({
    super.key,
    this.height = 50,
    this.text = '',
    this.onTap,
    this.isValid = true,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    if (widget.isValid) {
      setState(() {
        isPressed = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isValid) {
      setState(() {
        isPressed = false;
      });

      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isValid ? widget.onTap : null,
      onTapDown: widget.isValid ? _handleTapDown : null,
      onTapUp: widget.isValid ? _handleTapUp : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: isPressed ? 0.95 : 1.0,
        child: Stack(
          children: [
            Container(
              height: widget.height! + 5,
              decoration: BoxDecoration(
                color: widget.isValid ? kPrimaryLightColor : kPrimaryLightColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
            Container(
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isValid ? kPrimaryColor : kPrimaryLightColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
              child: Text(
                widget.text!,
                style: AppTextStyle.semibold(kTextSizeMd, kWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
