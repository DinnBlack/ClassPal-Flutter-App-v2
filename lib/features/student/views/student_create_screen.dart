import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button_camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class StudentCreateScreen extends StatelessWidget {
  const StudentCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kMarginXl,
          ),
          CustomButtonCamera(
            onImagePicked: (value) {},
          ),
          const SizedBox(
            height: kMarginXl,
          ),
          const CustomTextField(
            text: 'Họ và tên',
          ),
          const SizedBox(
            height: kMarginMd,
          ),
          const CustomTextField(
            text: 'Ngày sinh',
            isDateTimePicker: true,
          ),
          const SizedBox(
            height: kMarginLg,
          ),
          const CustomButton(
            text: 'Thêm',
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm học sinh',
      isSafeArea: false,
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
          color: kGreyColor,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
