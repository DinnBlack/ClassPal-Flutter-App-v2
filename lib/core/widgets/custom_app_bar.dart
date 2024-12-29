import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 60,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {

              },
              child: const Row(
                children: [
                  CustomAvatar(
                    size: 30,
                    text: 'Đinh Hoàng Phúc',
                  ),
                  SizedBox(
                    width: kMarginMd,
                  ),
                  Icon(
                    FontAwesomeIcons.chevronDown,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Text(
              'CLASSPAL',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: kTextSizeXl,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ZenDots'),
            ),
          ),
        ],
      ),
    );
  }
}
