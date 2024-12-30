import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomFeatureDialog extends StatelessWidget {
  final List<String> features;
  final List<Function()> onItemTaps;

  const CustomFeatureDialog({
    super.key,
    required this.features,
    required this.onItemTaps,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  features.length,
                      (index) {
                    return Column(
                      children: [
                        _CustomListItem(
                          index: index,
                          feature: features[index],
                          onItemTaps: onItemTaps,
                        ),
                        if (index < features.length - 1)
                          Container(
                            height: 1.0,
                            color: kGreyLightColor,
                          ),
                      ],
                    );
                  },
                ),
              ),
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
        _controller.forward();
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

void showCustomFeatureDialog(
    BuildContext context, List<String> features, List<Function()> onItemTaps) {
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
            child: CustomFeatureDialog(
              features: features,
              onItemTaps: onItemTaps,
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
