import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;

  const CustomBottomSheet({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 0.96,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(kBorderRadiusLg),
          ),
        ),
        child: child,
      ),
    );
  }

  static void showCustomBottomSheet(BuildContext context, Widget widget) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomBottomSheet(child: widget);
      },
    );
  }
}