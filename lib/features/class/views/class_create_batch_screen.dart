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
import '../bloc/class_bloc.dart';

class ClassCreateBatchScreen extends StatefulWidget {
  const ClassCreateBatchScreen({super.key});

  @override
  State<ClassCreateBatchScreen> createState() => _ClassCreateBatchScreenState();
}

class _ClassCreateBatchScreenState extends State<ClassCreateBatchScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isValid = false;
  final List<Map<String, String>> _classes = [];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      final isNameValid = Validators.validateName(_nameController.text) == null;

      _isValid = isNameValid && _nameController.text.trim().isNotEmpty;
    });
  }

  void _addClass() {
    setState(() {
      _classes.add({
        "name": _nameController.text.trim(),
        "color": _generateColor().value.toString(),
        // Lưu màu dưới dạng chuỗi số
      });
      _nameController.clear();
      _isValid = false;
    });
  }

// Hàm sinh màu ngẫu nhiên nhưng cố định
  Color _generateColor() {
    RandomColor randomColor = RandomColor();
    return randomColor.randomColor();
  }

  void _confirmDeleteClass(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận xoá"),
        content: const Text("Bạn có chắc chắn muốn xoá lớp học này này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Huỷ"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _classes.removeAt(index);
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
    return BlocConsumer<ClassBloc, ClassState>(
      listener: (context, state) {
        if (state is ClassCreateBatchInProgress) {
          CustomLoadingDialog.show(context);
        } else if (state is ClassCreateBatchSuccess) {
          CustomLoadingDialog.dismiss(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo lớp học đồng loạt thành công!',
            ),
          );
          Navigator.pop(context);
        } else if (state is ClassCreateBatchFailure) {
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Tạo lớp học đồng loạt thất bại!. Vui lòng thử lại!',
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          backgroundColor: kIsWeb ? kTransparentColor :kBackgroundColor,
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
              'Thông tin lớp học',
              style: AppTextStyle.semibold(kTextSizeMd),
            ),
            const SizedBox(height: kMarginLg),
            CustomTextField(
              text: 'Tên lớp học',
              autofocus: true,
              controller: _nameController,
              validator: Validators.validateName,
            ),
            const SizedBox(height: kMarginLg),
            CustomButton(
              text: '+ Thêm lớp học',
              onTap: _addClass,
              isValid: _isValid,
            ),
            const SizedBox(height: kMarginLg),
            if (_classes.isNotEmpty) ...[
              Text(
                'Danh sách lớp học',
                style: AppTextStyle.bold(kTextSizeMd),
              ),
              const SizedBox(height: kMarginLg),
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: kMarginMd,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  return CustomListItem(
                    isAnimation: false,
                    leading: CustomAvatar(
                      text: _classes[index]['name']!,
                      backgroundColor:
                          Color(int.parse(_classes[index]['color']!)),
                    ),
                    title: _classes[index]['name']!,
                    trailing: GestureDetector(
                      onTap: () => _confirmDeleteClass(index),
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
      title: 'Thêm lớp học đồng loạt',
      leftWidget: GestureDetector(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: _classes.isNotEmpty
          ? GestureDetector(
              onTap: () {
                context.read<ClassBloc>().add(
                      ClassCreateBatchStarted(
                        classes: _classes.map((e) => e["name"]!).toList(),
                      ),
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
