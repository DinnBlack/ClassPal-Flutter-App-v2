import 'package:classpal_flutter_app/core/utils/responsive.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/views/subject_screen.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_create_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/config/app_constants.dart';
import '../../toolkit/views/countdown_timer_screen.dart';
import '../../toolkit/views/random_student_picker_screen.dart';
import '../sub_features/roll_call/views/roll_call_screen.dart';

class ClassManagementScreen extends StatelessWidget {
  final List<ProfileModel>? students;

  ClassManagementScreen({super.key, this.students});

  final List<Map<String, dynamic>> features = [
    {"name": "Điểm danh", "icon": FontAwesomeIcons.checkCircle},
    {"name": "Quản lý điểm số", "icon": FontAwesomeIcons.userGraduate},
    {"name": "Quản lý học sinh", "icon": FontAwesomeIcons.userGraduate},
    {"name": "Bộ đếm thời gian", "icon": FontAwesomeIcons.clock},
    {"name": "Chọn ngẫu nhiên", "icon": FontAwesomeIcons.random},
  ];

  void onFeatureTapped(BuildContext context, String feature) {
    switch (feature) {
      case "Điểm danh":
        if (kIsWeb) {
          showCustomDialog(context, const RollCallScreen());
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: const RollCallScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        }

        break;
      case "Quản lý điểm số":
        if (kIsWeb) {
          showCustomDialog(context, const SubjectScreen());
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: const SubjectScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        }

        break;
      case "Quản lý học sinh":
        if (kIsWeb) {
          showCustomDialog(context, const StudentCreateScreen());
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: const StudentCreateScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        }

        break;
      case "Bộ đếm thời gian":
        if (kIsWeb) {
          showCustomDialog(context, CountdownTimerScreen());
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: CountdownTimerScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        }

        break;
      case "Chọn ngẫu nhiên":
        if (kIsWeb) {
          showCustomDialog(
            context,
            RandomStudentPickerScreen(
              students: students!,
            ),
          );
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: RandomStudentPickerScreen(
                students: students!,
              ),
              transitionType: PageTransitionType.slideFromBottom);
        }

        break;
      default:
        print("No route for feature: $feature");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
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
                    feature: features[index]['name'],
                    onItemTap: (feature) => onFeatureTapped(context, feature),
                  ),
                );
              },
            ),
          )
        : Center(
            child: SizedBox(
              height: 45,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  width: kMarginXl,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return _CustomItemWithIcon(
                    feature: features[index]['name'],
                    icon: features[index]['icon'],
                    onItemTap: (feature) => onFeatureTapped(context, feature),
                  );
                },
              ),
            ),
          );
  }
}

class _CustomItemWithIcon extends StatefulWidget {
  final String feature;
  final IconData icon;
  final Function(String) onItemTap;

  const _CustomItemWithIcon({
    super.key,
    required this.feature,
    required this.icon,
    required this.onItemTap,
  });

  @override
  State<_CustomItemWithIcon> createState() => _CustomItemWithIconState();
}

class _CustomItemWithIconState extends State<_CustomItemWithIcon>
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              widget.icon,
              size: 20,
              color: kPrimaryColor,
            ),
            const SizedBox(width: kMarginMd),
            Text(
              widget.feature,
              style: AppTextStyle.medium(kTextSizeXs),
            ),
          ],
        ),
      ),
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
