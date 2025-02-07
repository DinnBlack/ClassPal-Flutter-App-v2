import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/features/student/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'student_list_screen.dart';

class StudentGroupCreateScreen extends StatefulWidget {
  static const route = 'StudentGroupCreateScreen';
  final List<StudentModel> students;

  const StudentGroupCreateScreen({super.key, required this.students});

  @override
  _StudentGroupCreateScreenState createState() => _StudentGroupCreateScreenState();
}

class _StudentGroupCreateScreenState extends State<StudentGroupCreateScreen> {
  final TextEditingController _controller = TextEditingController();

  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: kMarginMd,
          ),
          CustomTextField(
            text: 'Họ và tên học sinh',
            controller: _controller,
            onChanged: _updateHasText,
            suffixIcon: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(kBorderRadiusMd),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: kMarginSm),
                decoration: BoxDecoration(
                  color: _hasText ? kPrimaryColor : kGreyLightColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  FontAwesomeIcons.plus,
                  size: 16,
                  color: _hasText ? Colors.white : kGreyColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: kMarginLg,
          ),
          StudentListScreen(isCreateListView: false, ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm nhóm',
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
