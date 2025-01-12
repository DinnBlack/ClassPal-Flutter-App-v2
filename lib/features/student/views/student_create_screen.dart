import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/features/student/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_text_field.dart';
import 'student_list_screen.dart';

class StudentCreateScreen extends StatefulWidget {
  static const route = 'StudentCreateScreen';
  final List<StudentModel> students;

  const StudentCreateScreen({super.key, required this.students});

  @override
  _StudentCreateScreenState createState() => _StudentCreateScreenState();
}

class _StudentCreateScreenState extends State<StudentCreateScreen> {
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
      backgroundColor: kWhiteColor,
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
          Expanded(child: StudentListScreen(students: widget.students,isCreateListView: true,)),
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
