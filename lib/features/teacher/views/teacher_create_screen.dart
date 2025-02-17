import 'dart:io';

import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/teacher_bloc.dart';

class TeacherCreateScreen extends StatefulWidget {
  const TeacherCreateScreen({super.key});

  @override
  State<TeacherCreateScreen> createState() => _TeacherCreateScreenState();
}

class _TeacherCreateScreenState extends State<TeacherCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      final isNameValid = Validators.validateName(_nameController.text) == null;

      final isEmailValid =
          Validators.validateEmail(_emailController.text) == null;

      _isValid = isNameValid &&
          _nameController.text.trim().isNotEmpty &&
          isEmailValid &&
          _emailController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherCreateInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is TeacherCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo giáo viên thành công')),
          );
          Navigator.pop(context);
        }

        if (state is TeacherCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo giáo viên thất bại')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: kBackgroundColor,
          body: _buildBody(),
        );
      },
    );
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(height: kMarginXxl),
            CustomButtonCamera(onImagePicked: (File? value) {}),
            const SizedBox(height: kMarginXxl),
            CustomTextField(
              text: 'Tên giáo viên',
              autofocus: true,
              controller: _nameController,
              validator: Validators.validateName,
            ),
            const SizedBox(height: kMarginMd),
            CustomTextField(
              text: 'Email',
              controller: _emailController,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: kMarginLg),
            CustomButton(
              text: 'Thêm giáo viên',
              onTap: () {
                context
                    .read<TeacherBloc>()
                    .add(TeacherCreateStarted(name: _nameController.text));
              },
              isValid: _isValid,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm giáo viên mới',
      leftWidget: GestureDetector(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
