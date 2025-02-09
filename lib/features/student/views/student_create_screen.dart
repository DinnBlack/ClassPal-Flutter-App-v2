import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/student_bloc.dart';
import 'student_list_screen.dart';

class StudentCreateScreen extends StatefulWidget {
  static const route = 'StudentCreateScreen';

  const StudentCreateScreen({super.key});

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
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          if (state is StudentCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo học sinh Thành công')),
            );
          } else if (state is StudentCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo học sinh thất bại')),
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
            height: kMarginMd,
          ),
          CustomTextField(
            text: 'Họ và tên học sinh',
            controller: _controller,
            onChanged: _updateHasText,
            suffixIcon: InkWell(
              onTap: () {
                // Add event to start student creation
                context
                    .read<StudentBloc>()
                    .add(StudentCreateStarted(name: _controller.text));
              },
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
          const Expanded(
              child: StudentListScreen(
            isCreateView: true,
          )),
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
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
