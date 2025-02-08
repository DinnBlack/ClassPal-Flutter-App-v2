import 'dart:io';

import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/class/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/class_bloc.dart';

class ClassInformationScreen extends StatefulWidget {
  final ClassModel currentClass;

  const ClassInformationScreen({super.key, required this.currentClass});

  @override
  State<ClassInformationScreen> createState() => _ClassInformationScreenState();
}

class _ClassInformationScreenState extends State<ClassInformationScreen> {
  final _classNameController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isValid = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _classNameController.addListener(_validateForm);
    _classNameController.text = widget.currentClass.name;
    print(widget.currentClass.avatarUrl);
    _validateForm();
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid =
          _classNameController.text.trim() != widget.currentClass.name.trim();
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: kMarginXxl),
            CustomButtonCamera(
              onImagePicked: (File? value) {},
              initialImageUrl: widget.currentClass.avatarUrl,
            ),
            const SizedBox(height: kMarginXxl),
            CustomTextField(
              controller: _classNameController,
              customFocusNode: _focusNode,
              readOnly: !_isEditing,
              autofocus: true,
              onChanged: (value) {
                _validateForm();
              },
              suffixIcon: InkWell(
                onTap: _toggleEdit,
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: kMarginSm),
                  decoration: BoxDecoration(
                    color: _isEditing ? kPrimaryColor : kGreyLightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.pen,
                    size: 16,
                    color: _isEditing ? Colors.white : kGreyColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: kMarginLg),
            BlocConsumer<ClassBloc, ClassState>(
              listener: (context, state) {
                if (state is ClassUpdateInProgress) {
                  CustomLoadingDialog.show(context);
                } else {
                  CustomLoadingDialog.dismiss(context);
                }
                if (state is ClassUpdateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thành công')),
                  );
                  Navigator.pop(context);
                } else if (state is ClassUpdateFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cập nhật thất bại')),
                  );
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: 'Lưu',
                  isValid: _isValid,
                  onTap: _isValid
                      ? () {
                          context.read<ClassBloc>().add(
                                ClassUpdateStarted(
                                    newName: _classNameController.text),
                              );
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thông tin lớp học',
      leftWidget: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
      ),
    );
  }
}
