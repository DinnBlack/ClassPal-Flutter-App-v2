import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/utils/responsive.dart';
import '../../profile/model/profile_model.dart';
import '../bloc/student_bloc.dart';

class StudentEditScreen extends StatefulWidget {
  static const route = 'StudentEditScreen';
  final ProfileModel student;

  const StudentEditScreen({super.key, required this.student});

  @override
  _StudentEditScreenState createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  late String _initialName;

  @override
  void initState() {
    super.initState();
    _initialName = widget.student.displayName ?? '';
    _nameController.text = _initialName;
    _nameController.addListener(_updateValidity);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateValidity);
    _nameController.dispose();
    super.dispose();
  }

  void _updateValidity() {
    setState(() {});
  }

  bool get _isValid {
    return _selectedImage != null || _nameController.text.trim() != _initialName.trim();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !Responsive.isMobile(context) ? kTransparentColor : kWhiteColor,
      appBar: _buildAppBar(context),
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentUpdateInProgress || state is StudentDeleteInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }
          if (state is StudentUpdateSuccess || state is StudentDeleteSuccess) {
            showTopSnackBar(
              Overlay.of(context),
               CustomSnackBar.success(
                message: state is StudentUpdateSuccess ? 'Cập nhật thành công' : 'Xóa học sinh thành công',
              ),
            );
            Navigator.pop(context);
          } else if (state is StudentUpdateFailure || state is StudentDeleteFailure) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: state is StudentUpdateFailure ? 'Cập nhật thất bại' : 'Xóa học sinh thất bại',
              ),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: !Responsive.isMobile(context) ? kPaddingLg: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kMarginXl),
          GestureDetector(
            onTap: _showImagePickerDialog,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: kPrimaryColor),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: kGreyMediumColor,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : (widget.student.avatarUrl.isNotEmpty)
                    ? NetworkImage(widget.student.avatarUrl) as ImageProvider
                    : const AssetImage('assets/images/default_avatar.png'),
              ),
            ),
          ),
          const SizedBox(height: kMarginMd),
          GestureDetector(
            onTap: _showImagePickerDialog,
            child: Text(
              'Chỉnh sửa ảnh đại diện',
              style: AppTextStyle.semibold(kTextSizeXs, kPrimaryColor),
            ),
          ),
          const SizedBox(height: kMarginXl),
          CustomTextField(
            controller: _nameController,
            text: _nameController.text,
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Lưu thay đổi',
            isValid: _isValid,
            onTap: _isValid
                ? () {
              context.read<StudentBloc>().add(StudentUpdateStarted(
                studentId: widget.student.id,
                imageFile: _selectedImage,
                name: _nameController.text.trim(),
              ));
            }
                : null,
          ),
          const SizedBox(height: kMarginMd),
          CustomButton(
            text: 'Xóa học sinh',
            backgroundColor: kRedColor,
            onTap: () {
              _showDeleteConfirmationDialog(context, widget.student);
            },
          ),
        ],
      ),
    );
  }


  void _showDeleteConfirmationDialog(
      BuildContext context, ProfileModel student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xác nhận xóa"),
          content: Text(
              "Bạn có chắc muốn hủy bỏ học sinh '${student.displayName}' không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<StudentBloc>()
                    .add(StudentDeleteStarted(studentId: student.id));
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child:
              const Text("Xác nhận", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
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


  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Chỉnh sửa học sinh',
      subtitle: widget.student.displayName,
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
