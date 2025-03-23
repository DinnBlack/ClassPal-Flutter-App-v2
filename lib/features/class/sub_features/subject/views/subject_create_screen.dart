import 'dart:io';
import 'package:classpal_flutter_app/core/utils/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../bloc/subject_bloc.dart';

class SubjectCreateScreen extends StatefulWidget {
  const SubjectCreateScreen({super.key});

  @override
  State<SubjectCreateScreen> createState() => _SubjectCreateScreenState();
}

class _SubjectCreateScreenState extends State<SubjectCreateScreen> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _scoreTypeController = TextEditingController();
  final List<String> _scoreTypes = [];
  File? _selectedImage;
  bool _isValid = false;

  @override
  void dispose() {
    _classNameController.dispose();
    _scoreTypeController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isValid =
          _classNameController.text.trim().isNotEmpty && _scoreTypes.isNotEmpty;
    });
  }

  bool get _validScoreType => _scoreTypeController.text.trim().isNotEmpty;

  void _addScoreType() {
    final scoreType = _scoreTypeController.text.trim();
    if (scoreType.isNotEmpty) {
      setState(() {
        _scoreTypes.add(scoreType);
        _scoreTypeController.clear();
      });
      _validateForm();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeScoreType(int index) {
    setState(() {
      _scoreTypes.removeAt(index);
      _validateForm();
    });
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chọn ảnh'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (!_isValid) return;

    context.read<SubjectBloc>().add(SubjectCreateStarted(
        name: _classNameController.text, gradeTypes: _scoreTypes));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is SubjectCreateInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is SubjectCreateSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo môn học Thành công!',
            ),
          );
          Navigator.pop(context);
        } else if (state is SubjectCreateFailure) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'Tạo môn học thất bại!',
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: !Responsive.isMobile(context) ? kTransparentColor : kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: kMarginXl),
            GestureDetector(
              onTap: _showImagePickerDialog,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: kPrimaryColor)),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: kWhiteColor,
                  backgroundImage: _selectedImage == null
                      ? null
                      : FileImage(_selectedImage!),
                  child: _selectedImage == null
                      ? const Icon(Icons.camera_alt,
                          size: 40, color: kPrimaryColor)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: kMarginXl),
            CustomTextField(
              controller: _classNameController,
              text: 'Tên môn học',
              autofocus: true,
              validator: (value) => Validators.validateRequiredText(
                  value, 'Vui lòng nhập tên môn học'),
              onChanged: (value) => _validateForm(),
            ),
            const SizedBox(height: kMarginMd),
            CustomTextField(
              controller: _scoreTypeController,
              text: 'Loại điểm',
              onChanged: (value) => setState(() {}),
              onFieldSubmitted: (p0) {
                if (_validScoreType) {
                  _addScoreType();
                }
              },
              suffixIcon: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.check,
                  color: _validScoreType ? kPrimaryColor : kGreyColor,
                ),
                onPressed: _validScoreType ? _addScoreType : null,
              ),
              validator: (value) => Validators.validateRequiredText(
                  value, 'Vui lòng nhập loại điểm'),
            ),
            const SizedBox(height: kMarginLg),
            if (_scoreTypes.isNotEmpty) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: kPaddingMd,
                  mainAxisSpacing: kPaddingMd,
                  childAspectRatio: 4,
                ),
                itemCount: _scoreTypes.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadiusMd),
                      border: Border.all(color: kGreyColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _scoreTypes[index],
                          style: AppTextStyle.medium(kTextSizeSm),
                        ),
                        const SizedBox(width: kMarginMd),
                        InkWell(
                          child: const FaIcon(
                            FontAwesomeIcons.xmark,
                            color: kGreyColor,
                          ),
                          onTap: () => _removeScoreType(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: kMarginLg),
            ],
            CustomButton(
              text: 'Tạo',
              isValid: _isValid,
              onTap: _onSubmit,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm môn học',
      leftWidget: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(FontAwesomeIcons.arrowLeft),
      ),
    );
  }
}
