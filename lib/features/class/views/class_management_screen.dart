import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/app_text_style.dart';

class ClassManagementScreen extends StatelessWidget {
  final bool? isHorizontal;

  ClassManagementScreen({super.key, this.isHorizontal = false});

  final List<String> features = [
    "Điểm danh",
    "Sắp xếp lịch học",
    "Quản lý điểm số",
    "Theo dõi tiến độ học tập",
    "Quản lý học sinh",
    "Gửi thông báo",
    "Quản lý giảng viên",
    "Lập kế hoạch học",
  ];

  @override
  Widget build(BuildContext context) {
    return isHorizontal == true
        ? SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: features.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: index == features.length - 1 ? 10 : 0,
                  ),
                  child: _CustomHorizontalItem(feature: features[index]),
                );
              },
            ),
          )
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    features[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          );
  }
}

class _CustomHorizontalItem extends StatefulWidget {
  final String feature;

  const _CustomHorizontalItem({
    super.key,
    required this.feature,
  });

  @override
  State<_CustomHorizontalItem> createState() => _CustomHorizontalItemState();
}

class _CustomHorizontalItemState extends State<_CustomHorizontalItem>
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
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kGreyLightColor,
                borderRadius: BorderRadius.circular(kBorderRadiusXl),
                border: const Border.symmetric(
                    vertical: BorderSide(width: 2, color: kGreyLightColor)),
              ),
              child: Text(
                widget.feature,
                style: AppTextStyle.medium(kTextSizeXs, kGreyLightColor),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(kBorderRadiusXl),
                border: Border.all(width: 2, color: kGreyMediumColor),
              ),
              child: Text(
                widget.feature,
                style: AppTextStyle.medium(kTextSizeXs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
