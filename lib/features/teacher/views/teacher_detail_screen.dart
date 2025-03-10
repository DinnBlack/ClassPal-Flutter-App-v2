import 'dart:io';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/widgets/custom_feature_dialog.dart';
import '../../profile/model/profile_model.dart';
import '../bloc/teacher_bloc.dart';

class TeacherDetailScreen extends StatefulWidget {
  static const route = 'TeacherDetailScreen';
  final ProfileModel teacher;

  const TeacherDetailScreen({super.key, required this.teacher});

  @override
  _TeacherDetailScreenState createState() => _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.teacher.displayName ?? '';
  }

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Xóa giáo viên',
      ],
      [
            () {
              _showDeleteConfirmationDialog(context);
        },
      ],
    );
  }

  // Function to show confirmation dialog for teacher deletion
  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa giáo viên này không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      // If confirmed, delete the teacher
      context.read<TeacherBloc>().add(
          TeacherDeleteStarted(teacherId: widget.teacher.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is TeacherDeleteInProgress) {
          return CustomLoadingDialog.show(context);
        } else if (state is TeacherDeleteSuccess) {
          CustomLoadingDialog.dismiss(context);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Xóa giáo viên thành công!',
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kIsWeb ? kTransparentColor : kWhiteColor,
          appBar: _buildAppBar(context),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kMarginXl),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: kPrimaryColor)),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: kGreyMediumColor,
              backgroundImage: NetworkImage(widget.teacher.avatarUrl),
            ),
          ),
          const SizedBox(height: kMarginXl),
          CustomTextField(
            readOnly: true,
            controller: _nameController,
            text: _nameController.text,
          ),
          const SizedBox(height: kMarginLg),
          CustomButton(
            text: 'Lưu thay đổi',
            onTap: () async {
              await ProfileService().deleteProfile(widget.teacher.id);
            },
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thông tin giáo viên',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {
          _showFeatureDialog(context);
        },
      ),
    );
  }
}
