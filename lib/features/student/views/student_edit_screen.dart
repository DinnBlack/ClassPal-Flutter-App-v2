import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/profile/model/profile_model.dart';
import 'package:classpal_flutter_app/features/student/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'student_list_screen.dart';

class StudentEditScreen extends StatefulWidget {
  static const route = 'StudentEditScreen';
  final ProfileModel student;

  const StudentEditScreen({super.key, required this.student});

  @override
  _StudentEditScreenState createState() => _StudentEditScreenState();
}

class _StudentEditScreenState extends State<StudentEditScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.displayName ?? '';
    // _birthDayController.text = widget.student.birthDate != null
    //     ? DateFormat('dd/MM/yyyy').format(widget.student.birthDate)
    //     : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
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
          CustomTextField(
            controller: _birthDayController,
            text: _birthDayController.text,
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
          const CustomButton(
            text: 'Xóa học sinh',
            backgroundColor: kRedColor,
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Chỉnh sửa học sinh',
      isSafeArea: false,
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
