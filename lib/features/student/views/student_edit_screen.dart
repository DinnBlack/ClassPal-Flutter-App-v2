import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: _buildAppBar(context),
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }
          if (state is StudentCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Xóa học sinh thành công')),
            );
            Navigator.pop(context);
          } else if (state is StudentCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Xóa học sinh thất bại: ${state.error}')),
            );
          }

          // Show loading dialog when deleting student
          if (state is StudentDeleteInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          // Show success or failure messages for delete
          if (state is StudentDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Xóa học sinh thành công')),
            );
            Navigator.pop(context); // Go back after successful deletion
          } else if (state is StudentDeleteFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi xóa học sinh: ${state.error}')),
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
          const SizedBox(
            height: kMarginXl,
          ),
          CustomAvatar(
            profile: widget.student,
            size: 100,
          ),
          const SizedBox(
            height: kMarginMd,
          ),
          Text(
            'Chỉnh sửa ảnh đại diện',
            style: AppTextStyle.semibold(kTextSizeXs, kPrimaryColor),
          ),
          const SizedBox(
            height: kMarginXl,
          ),
          CustomTextField(
            controller: _nameController,
            text: _nameController.text,
          ),
          const SizedBox(
            height: kMarginMd,
          ),
          const SizedBox(
            height: kMarginLg,
          ),
          const CustomButton(
            text: 'Lưu thay đổi',
          ),
          const SizedBox(
            height: kMarginMd,
          ),
           CustomButton(
            text: 'Xóa học sinh',
            backgroundColor: kRedColor,
            onTap:() {
              context.read<StudentBloc>().add(StudentDeleteStarted(studentId: widget.student.id));
            } ,
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Chỉnh sửa học sinh',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
          color: kGreyColor,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
