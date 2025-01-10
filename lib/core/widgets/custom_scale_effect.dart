import 'package:flutter/material.dart';

class CustomScaleEffect extends StatefulWidget {
  final Widget child;

  const CustomScaleEffect({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomScaleEffect> createState() => _CustomScaleEffectState();
}

class _CustomScaleEffectState extends State<CustomScaleEffect> with SingleTickerProviderStateMixin {
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
      },
      child: ScaleTransition(
        scale: _controller,
        child: widget.child,
      ),
    );
  }
}