import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget widget;
  final bool isDismissible;
  final double? maxWidth;  // Thêm tham số maxWidth (không bắt buộc)

  const CustomDialog({
    super.key,
    required this.widget,
    this.isDismissible = true,
    this.maxWidth,  // Cho phép truyền maxWidth không bắt buộc
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.elasticOut,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadiusXl),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? 650, // Nếu maxWidth không được truyền vào, mặc định là 650
              ),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, Widget widget, {bool isDismissible = true, double? maxWidth}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: isDismissible,
    barrierLabel: '',
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: Material(
            color: Colors.transparent,
            child: CustomDialog(
              widget: widget,
              isDismissible: isDismissible,
              maxWidth: maxWidth,  // Truyền maxWidth vào nếu có
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
