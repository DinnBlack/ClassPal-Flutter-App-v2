import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../shared/main_screen.dart';
import 'class_join_screen.dart';

class ClassCreateScreen extends StatefulWidget {
  static const route = 'ClassCreateScreen';
  final bool isClassCreateFirst;

  const ClassCreateScreen({super.key, this.isClassCreateFirst = false});

  @override
  _ClassCreateScreenState createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  late final PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void _navigateStep(int step) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        step,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep = step);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tạo lớp học mới',
        leftWidget: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: widget.isClassCreateFirst
          ? _buildWelcomeScreen()
          : _buildCreationSteps(),
    );
  }

  Widget _buildCreationSteps() {
    return SafeArea(
      child: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                  _buildStep2(),
                  _buildStep3(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) => _buildProgressBar(index)),
    );
  }

  Widget _buildProgressBar(int index) {
    return Expanded(
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: _currentStep >= index
              ? kPrimaryColor
              : kPrimaryColor.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        const SizedBox(height: kMarginXxl),
        CustomButtonCamera(onImagePicked: (File? value) {}),
        const SizedBox(height: kMarginXxl),
        const CustomTextField(text: 'Tên lớp học'),
        const SizedBox(height: kMarginLg),
        CustomButton(text: 'Tiếp tục', onTap: () => _navigateStep(1)),
      ],
    );
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          _buildStepTitle('Mời đồng giáo viên!',
              'Hãy mời đồng giáo viên để quản lý lớp học'),
          const SizedBox(height: kMarginXxl),
          CustomTextField(
            text: 'Email hoặc số điện thoại',
            suffixIcon:
                _buildIconButton(FontAwesomeIcons.plus, () => print('Add')),
          ),
          const SizedBox(height: kMarginLg),
          _buildInviteSection(),
          const SizedBox(height: kMarginXl),
          CustomButton(text: 'Mời', onTap: () => _navigateStep(2)),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bạn đã mời', style: AppTextStyle.bold(kTextSizeMd)),
        const SizedBox(height: kMarginLg),
        _buildInvitedEmail('phucdinn1803@gmail.com'),
        _buildInvitedEmail('dhphuc2003.work@gmail.com'),
      ],
    );
  }

  Widget _buildInvitedEmail(String email) {
    return CustomTextField(
      text: 'Email',
      defaultValue: email,
      suffixIcon:
          _buildIconButton(FontAwesomeIcons.xmark, () => print('Remove')),
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        const SizedBox(height: kMarginXxl),
        Image.asset('assets/images/congaduation.png'),
        const SizedBox(height: kMarginXxl),
        _buildStepTitle(
            'Tạo lớp học thành công!', 'Bạn đã có thể quản lý lớp học của bạn'),
        const SizedBox(height: kMarginXl),
        CustomButton(text: 'Hoàn tất', onTap: () => Navigator.pop(context)),
      ],
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      children: [
        Text(title, style: AppTextStyle.bold(kTextSizeXxl)),
        Text(subtitle, style: AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
      ],
    );
  }

  Widget _buildWelcomeScreen() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(height: kMarginLg),
            _buildHeaderWithSkip(),
            const SizedBox(height: kMarginLg),
            _buildStepTitle(
                'Chào mừng Giáo viên!', 'Hãy tạo lớp học của bạn để quản lý'),
            const SizedBox(height: kMarginLg),
            const CustomTextField(text: 'Tên trường học'),
            const SizedBox(height: kMarginLg),
            const CustomButton(text: 'Tạo lớp học'),
            const SizedBox(height: kMarginLg),
            _buildJoinClassLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWithSkip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, MainScreen.route),
          child: Text('Bỏ qua',
              style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor)),
        ),
      ],
    );
  }

  Widget _buildJoinClassLink() {
    return RichText(
      text: TextSpan(
        style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
        children: [
          const TextSpan(text: 'Bạn đã được mời từ lớp học? '),
          TextSpan(
            text: 'Tham gia',
            style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => Navigator.pushNamed(context, ClassJoinScreen.route),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: kGreyColor, size: 16),
      onPressed: onTap,
    );
  }
}
