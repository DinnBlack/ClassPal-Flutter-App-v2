import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

import '../config/app_constants.dart';

class CustomButton extends StatefulWidget {
  final double? height;
  final String? text;
  final VoidCallback? onTap;
  final bool isValid;
  final Color? backgroundColor;
  final bool isBackground;

  const CustomButton({
    super.key,
    this.height = 50.0,
    this.text = '',
    this.onTap,
    this.isValid = true,
    this.backgroundColor,
    this.isBackground = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    final buttonColor = widget.backgroundColor ?? kPrimaryColor;

    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        await _controller.forward();
        widget.onTap!();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(
          children: [
            // Thêm lớp nền nếu isBackground = true
            if (widget.isBackground)
              Container(
                height: widget.height! + 5,
                decoration: BoxDecoration(
                  color: widget.isValid
                      ? buttonColor.withOpacity(0.5)
                      : buttonColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(kBorderRadiusXl),
                ),
              ),
            Container(
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isValid
                    ? buttonColor
                    : buttonColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kBorderRadiusXl),
              ),
              child: Text(
                widget.text!,
                style: AppTextStyle.semibold(kTextSizeSm, kWhiteColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
