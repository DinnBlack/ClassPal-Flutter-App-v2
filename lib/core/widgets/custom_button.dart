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
            Container(
              height: widget.height! + 5,
              decoration: BoxDecoration(
                color: widget.isValid
                    ? kPrimaryLightColor
                    : kPrimaryLightColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
            Container(
              height: widget.height,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.isValid
                    ? kPrimaryColor
                    : kPrimaryLightColor.withOpacity(0.5),
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
