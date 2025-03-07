import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../post_create_screen.dart';

class PostCreateButton extends StatefulWidget {
  const PostCreateButton({super.key});

  @override
  State<PostCreateButton> createState() => _PostCreateButtonState();
}

class _PostCreateButtonState extends State<PostCreateButton>
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
        if (kIsWeb) {
          showCustomDialog(context, const PostCreateScreen(),);
        } else {
          CustomPageTransition.navigateTo(
              context: context,
              page: const PostCreateScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        }
      },
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          padding: const EdgeInsets.all(kPaddingMd),
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(kBorderRadiusLg),
          ),
          child: Row(
            children: [
              const CustomAvatar(
                imageAsset: 'assets/images/student.jpg',
              ),
              const SizedBox(
                width: kMarginMd,
              ),
              Text(
                'Tạo bài đăng mới',
                style: AppTextStyle.medium(
                  kTextSizeSm,
                ),
              ),
              const Spacer(),
              const Icon(
                FontAwesomeIcons.cameraRetro,
                color: kPrimaryColor,
              ),
              const SizedBox(
                width: kMarginMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
