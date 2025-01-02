import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final Widget widget;

  const CustomDialog({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Material(
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
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListItem extends StatefulWidget {
  const _CustomListItem({
    super.key,
    required this.index,
    required this.feature,
    required this.onItemTaps,
  });

  final int index;
  final String feature;
  final List<Function()> onItemTaps;

  @override
  State<_CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<_CustomListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.9,
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
        Navigator.of(context).pop();
        widget.onItemTaps[widget.index]();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          color: kTransparentColor,
          height: 50,
          width: double.infinity,
          child: Center(
            child: Text(
              widget.feature,
              style: AppTextStyle.medium(kTextSizeSm),
            ),
          ),
        ),
      ),
    );
  }
}

void showCustomDialog(BuildContext context, Widget widget) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
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
