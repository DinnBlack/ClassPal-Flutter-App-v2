import 'dart:io';
import 'package:classpal_flutter_app/features/class/sub_features/subject/models/subject_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:collection/collection.dart';
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

class SubjectEditScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectEditScreen({super.key, required this.subject});

  @override
  State<SubjectEditScreen> createState() => _SubjectEditScreenState();
}

class _SubjectEditScreenState extends State<SubjectEditScreen> {
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _scoreTypeController = TextEditingController();
  final List<String> _scoreTypes = [];
  File? _selectedImage;
  bool _isValid = false;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _classNameController.text = widget.subject.name;
    _scoreTypes.addAll(widget.subject.gradeTypes.map((e) => e.name));
    _classNameController.addListener(_checkChanges);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _validateForm();
    });
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _scoreTypeController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final bool isNameChanged =
        _classNameController.text.trim() != widget.subject.name;

    final Set<String> initialGradeTypes =
    widget.subject.gradeTypes.map((s) => s.name).toSet();
    final bool isGradeTypesChanged = !const ListEquality().equals(
      widget.subject.gradeTypes.map((s) => s.name).toList(),
      _scoreTypes,
    );

    final bool isImageChanged = _selectedImage != null;

    setState(() {
      _isChanged = isNameChanged || isGradeTypesChanged || isImageChanged;
      _isValid = _isChanged && _classNameController.text.trim().isNotEmpty && _scoreTypes.isNotEmpty;
    });
  }

  bool get _validScoreType => _scoreTypeController.text.trim().isNotEmpty;

  void _checkChanges() {
    _validateForm();
  }

  void _addScoreType() {
    final scoreType = _scoreTypeController.text.trim();
    if (scoreType.isNotEmpty) {
      setState(() {
        _scoreTypes.add(scoreType);
        _scoreTypeController.clear();
        _validateForm();
      });
    }
  }

  void _removeScoreType(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa loại điểm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _scoreTypes.removeAt(index);
                _validateForm();
              });
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _validateForm();
      });
    }
  }

  void _onUpdateSubject(BuildContext context) {
    final String newName = _classNameController.text;
    final String initialName = widget.subject.name;
    final List<String> initialGradeTypes =
        widget.subject.gradeTypes.map((s) => s.name).toList();
    final Set<String> newGradeTypes = _scoreTypes.toSet();

    final String? updatedName = (newName != initialName) ? newName : null;
    final List<String>? updatedGradeTypes =
        (newGradeTypes != initialGradeTypes) ? _scoreTypes : null;

    context.read<SubjectBloc>().add(SubjectUpdateStarted(
        subject: widget.subject,
        name: updatedName,
        gradeTypes: _scoreTypes));
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is SubjectUpdateInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is SubjectUpdateSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Cập nhật môn học Thành công!',
            ),
          );
          Navigator.pop(context);
        } else if (state is SubjectUpdateFailure) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'Cập nhật môn học thất bại!',
            ),
          );
        }
      },
      child: Scaffold( backgroundColor: kIsWeb ? kTransparentColor : kBackgroundColor,
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
                  backgroundColor: kGreyMediumColor,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.subject.avatarUrl.isNotEmpty)
                          ? NetworkImage(widget.subject.avatarUrl)
                              as ImageProvider
                          : const AssetImage(
                              'assets/images/default_avatar.png'),
                ),
              ),
            ),
            const SizedBox(height: kMarginMd),
            GestureDetector(
              onTap: _showImagePickerDialog,
              child: Text(
                'Chỉnh sửa ảnh môn học',
                style: AppTextStyle.semibold(kTextSizeXs, kPrimaryColor),
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
              text: 'Lưu thay đổi',
              isValid: _isValid,
              onTap: _isChanged ? () => _onUpdateSubject(context) : null,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Chỉnh sửa môn học',
      subtitle: widget.subject.name,
      leftWidget: InkWell(
        onTap: () {
          if (_isChanged) {
            _showExitConfirmationDialog(context);
          } else{
            Navigator.pop(context);
          }
        },
        child: const Icon(FontAwesomeIcons.xmark),
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận thoát'),
        content: const Text('Bạn có chắc chắn muốn thoát? Những thay đổi chưa lưu sẽ bị mất.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Thoát', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

}
