import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../shared/main_screen.dart';

class ClassJoinScreen extends StatelessWidget {
  static const route = 'ClassJoinScreen';

  const ClassJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
          child: Column(
            children: [
              const SizedBox(height: kMarginLg),
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
              const SizedBox(height: kMarginLg),
              Text(
                'Chào mừng Giáo viên!',
                style: AppTextStyle.bold(kTextSizeXxl),
              ),
              Text(
                'Hãy quét mã QR hoặc nhập mã để tham gia',
                style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
              ),
              const SizedBox(height: kMarginLg),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadiusMd),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kBorderRadiusMd),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String? code = barcode.rawValue;
                        if (code != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mã QR: $code')),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: kMarginLg),
              Text(
                'Hoặc',
                style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
              ),
              const SizedBox(height: kMarginLg),
              const CustomTextField(
                text: 'Nhập mã lớp học',
              ),
              const SizedBox(height: kMarginLg),
              const CustomButton(
                text: 'Tham gia lớp',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
