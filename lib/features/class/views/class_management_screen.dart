import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/views/subject_screen.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/config/app_constants.dart';
import '../sub_features/roll_call/views/roll_call_screen.dart';

class ClassManagementScreen extends StatelessWidget {
  final bool? isHorizontal;

  ClassManagementScreen({super.key, this.isHorizontal = false});

  // Define a list of features
  final List<String> features = [
    "Điểm danh",
    "Quản lý điểm số",
    "Quản lý học sinh",
    "Gửi thông báo",
  ];

  void onFeatureTapped(BuildContext context, String feature) {
    switch (feature) {
      case "Điểm danh":
        CustomPageTransition.navigateTo(
            context: context,
            page: const RollCallScreen(),
            transitionType: PageTransitionType.slideFromBottom);
        break;
      case "Quản lý điểm số":
        CustomPageTransition.navigateTo(
            context: context,
            page: const SubjectScreen(),
            transitionType: PageTransitionType.slideFromBottom);
        break;
      case "Quản lý học sinh":
        CustomPageTransition.navigateTo(
            context: context,
            page: const StudentCreateScreen(),
            transitionType: PageTransitionType.slideFromBottom);
        break;
      case "Gửi thông báo":
        Navigator.pushNamed(context, '/send-notification');
        break;
      default:
        print("No route for feature: $feature");
        break;
    }
  }

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
                  child: _CustomHorizontalItem(
                    feature: features[index],
                    onItemTap: (feature) => onFeatureTapped(context, feature),
                  ),
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
              return GestureDetector(
                onTap: () => onFeatureTapped(context, features[index]),
                // Handle tap and navigate here
                child: Container(
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
                ),
              );
            },
          );
  }
}

class _CustomHorizontalItem extends StatefulWidget {
  final String feature;
  final Function(String) onItemTap;

  const _CustomHorizontalItem({
    super.key,
    required this.feature,
    required this.onItemTap,
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
        widget.onItemTap(widget.feature);
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(
          children: [
            Container(
              height: 45,
              padding: const EdgeInsets.all(kPaddingMd),
              decoration: BoxDecoration(
                color: kGreyLightColor,
                borderRadius: BorderRadius.circular(kBorderRadiusXl),
                border: Border.symmetric(
                    vertical: BorderSide(width: 2, color: kGreyLightColor)),
              ),
              child: Text(
                widget.feature,
                style: AppTextStyle.medium(kTextSizeXs, kGreyLightColor),
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.all(kPaddingMd),
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
