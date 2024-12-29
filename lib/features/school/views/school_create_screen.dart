import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:classpal_flutter_app/features/school/views/school_join_screen.dart';
import 'package:classpal_flutter_app/shared/main_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SchoolCreateScreen extends StatelessWidget {
  static const route = 'SchoolCreateScreen';

  const SchoolCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(
              height: kMarginLg,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: const Icon(FontAwesomeIcons.arrowLeft),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MainScreen.route);
                  },
                  child: Text(
                    'Bỏ qua',
                    style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            Text(
              'Chào mừng lãnh đạo trường!',
              style: AppTextStyle.bold(kTextSizeXxl),
            ),
            Text(
              'Hãy tạo trường học của bạn để quản lý',
              style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const CustomTextField(
              text: 'Tên trường học',
            ),
            const SizedBox(
              height: kMarginMd,
            ),
            const CustomTextField(
              text: 'Địa chỉ',
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            const CustomButton(
              text: 'Tạo trường học ',
            ),
            const SizedBox(
              height: kMarginLg,
            ),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Bạn đã được mời từ trường học? ',
                        style: AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
                    TextSpan(
                      text: 'Tham gia',
                      style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, SchoolJoinScreen.route);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
