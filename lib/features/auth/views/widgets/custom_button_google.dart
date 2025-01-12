
import 'package:flutter/material.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/utils/app_text_style.dart';

class CustomButtonGoogle extends StatefulWidget {
  final double? height;
  final String? text;
  final VoidCallback? onTap;

  const CustomButtonGoogle({
    super.key,
    this.height = 50,
    this.text = 'Tiếp tục với Google',
    this.onTap,
  });

  @override
  State<CustomButtonGoogle> createState() => _CustomButtonGoogleState();
}

class _CustomButtonGoogleState extends State<CustomButtonGoogle>
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
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(kBorderRadiusXl),
            border: Border.all(
              color: kGreyColor,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/google_icon.png',
                height: 30,
                width: 30,
              ),
              const SizedBox(width: kMarginMd),
              Text(
                widget.text!,
                style: AppTextStyle.semibold(
                  kTextSizeSm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
