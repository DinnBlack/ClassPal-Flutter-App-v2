import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../utils/app_text_style.dart';

class CustomTabBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;
  final List<String> tabTitles;
  final double lineHeight;
  final double linePadding;
  final double tabBarWidthRatio;
  final double tabBarHeight;

  const CustomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.tabTitles,
    this.lineHeight = 2,
    this.linePadding = 20,
    this.tabBarWidthRatio = 2 / 3,
    this.tabBarHeight = 50.0,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double totalLength = screenWidth * widget.tabBarWidthRatio;
    double tabWidth = totalLength / widget.tabTitles.length;
    double lineWidth = tabWidth;

    return SizedBox(
      width: totalLength,
      height: widget.tabBarHeight,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            left: _getTabPosition(widget.currentIndex, tabWidth, lineWidth),
            bottom: widget.linePadding,
            child: Container(
              width: lineWidth,
              height: widget.lineHeight,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
          ),
          Row(
            children: List.generate(widget.tabTitles.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTabTapped(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.tabTitles[index],
                        style: AppTextStyle.semibold(
                          kTextSizeXs,
                          widget.currentIndex == index
                              ? kPrimaryColor
                              : kGreyColor,
                        ),
                      ),
                      SizedBox(height: widget.linePadding),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  double _getTabPosition(int index, double tabWidth, double lineWidth) {
    double tabPosition = tabWidth * index;
    return tabPosition + (tabWidth / 2) - (lineWidth / 2);
  }
}