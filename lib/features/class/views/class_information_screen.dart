import 'dart:io';

import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/class/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button_camera.dart';
import '../../../core/widgets/custom_text_field.dart';

class ClassInformationScreen extends StatefulWidget {
  final ClassModel currentClass;

  const ClassInformationScreen({super.key, required this.currentClass});

  @override
  State<ClassInformationScreen> createState() => _ClassInformationScreenState();
}

class _ClassInformationScreenState extends State<ClassInformationScreen> {
  final _classNameController = TextEditingController();
  final _focusNode = FocusNode(); // FocusNode to handle focus behavior
  bool _isValid = false;
  bool _isEditing = false; // To track if the text field is in edit mode

  @override
  void initState() {
    super.initState();
    _classNameController.addListener(_validateForm);
    _classNameController.text =
        widget.currentClass.name; // Set the initial class name
    _validateForm(); // Validate the initial state
  }

  void _validateForm() {
    setState(() {
      // If the text has changed from the initial class name, set _isValid to true
      _isValid =
          _classNameController.text.trim() != widget.currentClass.name.trim();
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _focusNode.requestFocus(); // Focus the text field when editing
      } else {
        _focusNode.unfocus(); // Remove focus when done editing
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
            CustomButtonCamera(onImagePicked: (File? value) {}),
            const SizedBox(height: kMarginXxl),
            CustomTextField(
              controller: _classNameController,
              customFocusNode: _focusNode,
              // Attach the focus node
              readOnly: !_isEditing,
              // Set readOnly based on _isEditing
              autofocus: false,
              onChanged: (value) {
                _validateForm(); // Validate when text changes
              },
              suffixIcon: InkWell(
                onTap: _toggleEdit, // Toggle edit mode on icon tap
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
            CustomButton(
              text: 'Lưu',
              isValid: _isValid,
              onTap: () {

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
