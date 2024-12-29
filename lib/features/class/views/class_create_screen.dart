import 'dart:io';

import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/widgets/custom_button_camera.dart';
import '../../../shared/main_screen.dart';
import 'class_join_screen.dart';

class ClassCreateScreen extends StatefulWidget {
  static const route = 'ClassCreateScreen';
  final bool isClassCreateFirst;

  const ClassCreateScreen({Key? key, this.isClassCreateFirst = false}) : super(key: key);

  @override
  _ClassCreateScreenState createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void _nextStep() {
    if (_pageController.hasClients && _pageController.page! < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_pageController.hasClients && _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: widget.isClassCreateFirst
          ? buildClassCreateFirst(context)
          : buildClassCreate(context),
    );
  }

  SafeArea buildClassCreate(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(height: kMarginLg),
            Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    child: const Icon(FontAwesomeIcons.arrowLeft),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Tạo lớp học mới',
                    style: AppTextStyle.bold(kTextSizeLg),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kMarginMd),
            buildProgressIndicator(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  buildClassCreateStep1(),
                  buildClassCreateStep2(),
                  buildClassCreateStep3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildProgressIndicator() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kBorderRadiusXl),
      ),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Container(
              height: 5,
              decoration: BoxDecoration(
                color: _currentStep >= index ? kPrimaryColor : kPrimaryColor.withOpacity(0.3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Column buildClassCreateStep1() {
    return Column(
      children: [
        const SizedBox(height: kMarginXxl),
        CustomButtonCamera(
          onImagePicked: (File? value) {}, // Implement functionality
        ),
        const SizedBox(height: kMarginXxl),
        const CustomTextField(
          text: 'Tên lớp học',
        ),
        const SizedBox(height: kMarginLg),
        CustomButton(
          text: 'Tiếp tục',
          onTap: _nextStep,
        ),
      ],
    );
  }

  SingleChildScrollView buildClassCreateStep2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          Text(
            'Mời đồng giáo viên!',
            style: AppTextStyle.bold(kTextSizeXxl),
          ),
          Text(
            'Hãy mời đồng giáo viên để quản lý lớp học',
            style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
          ),
          const SizedBox(height: kMarginXxl),
          const CustomTextField(
            defaultValue: 'Mời bằng Email',
            options: ['Mời bằng Email', 'Mời bằng Số điện thoại'],
          ),
          const SizedBox(height: kMarginLg),
          const CustomTextField(
            text: 'Email',
            suffixIcon: Icon(FontAwesomeIcons.plus, color: kGreyColor, size: 16),
          ),
          const SizedBox(height: kMarginLg),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bạn đã mời',
              style: AppTextStyle.bold(kTextSizeMd),
            ),
          ),
          const SizedBox(height: kMarginLg),
          const CustomTextField(
            text: 'Email',
            defaultValue: 'phucdinn1803@gmail.com',
            suffixIcon: Icon(FontAwesomeIcons.xmark, color: kGreyColor, size: 16),
          ),
          const SizedBox(height: kMarginLg),
          const CustomTextField(
            text: 'Email',
            defaultValue: 'dhphuc2003.work@gmail.com',
            suffixIcon: Icon(FontAwesomeIcons.xmark, color: kGreyColor, size: 16),
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Mời',
            onTap: _nextStep,
          ),
        ],
      ),
    );
  }

  Column buildClassCreateStep3() {
    return Column(
      children: [
        const SizedBox(height: kMarginXxl),
        Image.asset('assets/images/congaduation.png'),
        const SizedBox(height: kMarginXxl),
        Text(
          'Tạo lớp học thành công!',
          style: AppTextStyle.bold(kTextSizeXxl),
        ),
        Text(
          'Bạn đã có thể quản lý lớp học của bạn',
          style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
        ),
        const SizedBox(height: kMarginLg),
        const CustomButton(
          text: 'Hoàn tất',
        ),
      ],
    );
  }

  SafeArea buildClassCreateFirst(BuildContext context) {
    return SafeArea(
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
              'Hãy tạo lớp học của bạn để quản lý',
              style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
            ),
            const SizedBox(height: kMarginLg),
            const CustomTextField(
              text: 'Tên trường học',
            ),
            const SizedBox(height: kMarginLg),
            const CustomButton(
              text: 'Tạo lớp học',
            ),
            const SizedBox(height: kMarginLg),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Bạn đã được mời từ lớp học? ',
                      style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                    ),
                    TextSpan(
                      text: 'Tham gia',
                      style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, ClassJoinScreen.route);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
