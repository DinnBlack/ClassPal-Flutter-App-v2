import 'dart:io';
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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.displayName ?? '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(context),
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentUpdateAvatarInProgress ||
              state is StudentDeleteInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }
          if (state is StudentUpdateAvatarSuccess ||
              state is StudentDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state is StudentUpdateAvatarSuccess
                      ? 'Cập nhật thành công'
                      : 'Xóa học sinh thành công')),
            );
            Navigator.pop(context);
          } else if (state is StudentUpdateAvatarFailure ||
              state is StudentDeleteFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lỗi: ')),
            );
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                    : (widget.student.avatarUrl.isNotEmpty)
                        ? NetworkImage(widget.student.avatarUrl)
                            as ImageProvider
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
            onTap: () {
              if (_selectedImage != null) {
                context.read<StudentBloc>().add(StudentUpdateAvatarStarted(
                      profile: widget.student,
                      imageFile: _selectedImage!,
                    ));
              }
            },
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
