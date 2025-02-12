import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:classpal_flutter_app/features/class/bloc/class_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_notification_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../shared/main_screen.dart';
import 'class_join_screen.dart';

class ClassCreateScreen extends StatefulWidget {
  static const route = 'ClassCreateScreen';
  final bool isClassCreateFirst;
  final bool isClassSchoolCreateView;

  const ClassCreateScreen(
      {super.key,
      this.isClassCreateFirst = false,
      this.isClassSchoolCreateView = false});

  @override
  _ClassCreateScreenState createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  late final PageController _pageController;
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _emailController = TextEditingController();
  final List<String> _invitedEmails = [];
  bool _isValid = false;
  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _classNameController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      final isNameValid = Validators.validateRequiredText(
              _classNameController.text, 'Tên lớp không được để trống!') ==
          null;

      _isValid = isNameValid && _classNameController.text.trim().isNotEmpty;
    });
  }

  void _addEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && !_invitedEmails.contains(email)) {
      setState(() {
        _invitedEmails.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _invitedEmails.remove(email);
    });
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
          icon: const Icon(FontAwesomeIcons.xmark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: widget.isClassCreateFirst
          ? _buildWelcomeScreen()
          : widget.isClassSchoolCreateView
              ? _buildClassSchoolCreationSteps()
              : _buildClassPersonalCreationSteps(),
    );
  }

  Widget _buildClassPersonalCreationSteps() {
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

  Widget _buildClassSchoolCreationSteps() {
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
                  _buildClassSchoolStep2(),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          CustomButtonCamera(onImagePicked: (File? value) {}),
          const SizedBox(height: kMarginXxl),
          CustomTextField(
            text: 'Tên lớp học',
            autofocus: true,
            controller: _classNameController,
            onChanged: (_) => _validateForm(),
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Tiếp tục',
            onTap: _isValid ? () => _navigateStep(1) : null,
            isValid: _isValid,
          ),
        ],
      ),
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
            controller: _emailController,
            onChanged: _updateHasText,
            suffixIcon: InkWell(
              onTap: _addEmail,
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: kMarginSm),
                decoration: BoxDecoration(
                  color: _hasText ? kPrimaryColor : kGreyLightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: _hasText ? Colors.white : kGreyColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: kMarginLg),
          _buildInviteSection(),
          CustomButton(
            text: 'Mời',
            isValid: _invitedEmails.isNotEmpty,
            onTap: _invitedEmails.isNotEmpty ? () => _navigateStep(2) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildClassSchoolStep2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          _buildStepTitle('Thêm giáo viên phụ trách!',
              'Hãy phân công giáo viên để quản lý lớp học'),
          const SizedBox(height: kMarginXxl),
          CustomButton(
            text: 'Phân công',
            onTap: () => context
                .read<ClassBloc>()
                .add(ClassSchoolCreateStarted(name: _classNameController.text)),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteSection() {
    if (_invitedEmails.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bạn đã mời', style: AppTextStyle.bold(kTextSizeMd)),
        const SizedBox(
          height: kMarginLg,
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _invitedEmails.length,
          itemBuilder: (context, index) =>
              _buildInvitedEmail(_invitedEmails[index]),
          separatorBuilder: (context, index) =>
              const SizedBox(height: kMarginMd),
        ),
        const SizedBox(height: kMarginLg),
      ],
    );
  }

  Widget _buildInvitedEmail(String email) {
    return CustomTextField(
      text: 'Email',
      defaultValue: email,
      controller: TextEditingController(text: email),
      readOnly: true,
      suffixIcon: InkWell(
        onTap: () {
          _removeEmail(email);
        },
        borderRadius: BorderRadius.circular(kBorderRadiusMd),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: kMarginSm),
          decoration: const BoxDecoration(
            color: kRedColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            FontAwesomeIcons.xmark,
            size: 16,
            color: _hasText ? Colors.white : kGreyColor,
          ),
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: kMarginXxl),
          Image.asset('assets/images/congaduation.png'),
          const SizedBox(height: kMarginXxl),
          _buildStepTitle('Tạo lớp học thành công!',
              'Bạn đã có thể quản lý lớp học của bạn'),
          const SizedBox(height: kMarginXl),
          CustomButton(
            text: 'Hoàn tất',
            onTap: () {
              context.read<ClassBloc>().add(
                  ClassPersonalCreateStarted(name: _classNameController.text));
              Navigator.pop(context);
              CustomNotificationDialog(
                title: 'Tạo lớp học cá nhân thành công!',
                description: 'Bạn có thể quản lý lớp học của bạn',
                dialogType: DialogType.success,
                onOk: () => Navigator.pop(context),
                onCancel: () {},
              );
            },
          ),
        ],
      ),
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
}
