import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:random_color/random_color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_avatar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_list_item.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/teacher_bloc.dart';

class TeacherCreateBatchScreen extends StatefulWidget {
  const TeacherCreateBatchScreen({super.key});

  @override
  State<TeacherCreateBatchScreen> createState() =>
      _TeacherCreateBatchScreenState();
}

class _TeacherCreateBatchScreenState extends State<TeacherCreateBatchScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isValid = false;
  final List<Map<String, String>> _teachers = [];

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

  void _addTeacher() {
    setState(() {
      _teachers.add({
        "name": _nameController.text.trim(),
        "email": _emailController.text.trim(),
        "color": _generateColor().value.toString(),
        // Lưu màu dưới dạng chuỗi số
      });
      _nameController.clear();
      _emailController.clear();
      _isValid = false;
    });
  }

// Hàm sinh màu ngẫu nhiên nhưng cố định
  Color _generateColor() {
    RandomColor randomColor = RandomColor();
    return randomColor.randomColor();
  }

  void _confirmDeleteTeacher(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: const Text("Bạn có chắc chắn muốn xoá giáo viên này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _teachers.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Xoá", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherCreateBatchInProgress) {
          CustomLoadingDialog.show(context);
        } else if (state is TeacherCreateBatchSuccess) {
          CustomLoadingDialog.dismiss(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo giáo viên đồng loạt thành công!',
            ),
          );
          Navigator.pop(context);
        } else if (state is TeacherCreateBatchFailure) {
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo giáo viên đồng loạt thất bại!. Vui lòng thử lại!',
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: kIsWeb ? kTransparentColor : kBackgroundColor,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kMarginLg),
            Text(
              'Thông tin giáo viên',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
            const SizedBox(height: kMarginLg),
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
              text: '+ Thêm giáo viên',
              onTap: _addTeacher,
              isValid: _isValid,
            ),
            const SizedBox(height: kMarginLg),
            if (_teachers.isNotEmpty) ...[
              Text(
                'Danh sách giáo viên',
                style: AppTextStyle.bold(kTextSizeMd),
              ),
              const SizedBox(height: kMarginLg),
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: kMarginMd,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _teachers.length,
                itemBuilder: (context, index) {
                  return CustomListItem(
                    isAnimation: false,
                    leading: CustomAvatar(
                      text: _teachers[index]['name']!,
                      backgroundColor:
                          Color(int.parse(_teachers[index]['color']!)),
                    ),
                    title: _teachers[index]['name']!,
                    subtitle: _teachers[index]['email']!,
                    trailing: GestureDetector(
                      onTap: () => _confirmDeleteTeacher(index),
                      child: Padding(
                        padding: const EdgeInsets.all(kPaddingMd),
                        child: Icon(
                          FontAwesomeIcons.xmark,
                          size: 16,
                          color: kRedColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm giáo viên đồng loạt',
      leftWidget: GestureDetector(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: _teachers.isNotEmpty
          ? GestureDetector(
              onTap: () {
                final List<String> names =
                    _teachers.map((teacher) => teacher['name']!).toList();
                final List<String> emails =
                    _teachers.map((teacher) => teacher['name']!).toList();
                context.read<TeacherBloc>().add(
                      TeacherCreateBatchStarted(
                          teachers: List<Map<String, String>>.from(_teachers)),
                    );
              },
              child: Text(
                'Lưu',
                style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
              ),
            )
          : Text(
              'Lưu',
              style: AppTextStyle.semibold(kTextSizeSm, Colors.grey),
            ),
    );
  }
}
