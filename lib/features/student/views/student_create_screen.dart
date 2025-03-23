import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/utils/responsive.dart';
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
  final FocusNode _focusNode = FocusNode(); // Thêm FocusNode

  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Hủy FocusNode khi không cần thiết
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !Responsive.isMobile(context) ? kTransparentColor : kBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocListener<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is StudentCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          if (state is StudentCreateSuccess) {
            _controller.clear();
            _updateHasText('');

            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: 'Tạo học sinh thành công!',
              ),
            );

            // Giữ focus trên TextField sau khi tạo thành công
            if (kIsWeb) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _focusNode.requestFocus();
              });
            }
          } else if (state is StudentCreateFailure) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: 'Tạo học sinh thất bại!',
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
      padding:  EdgeInsets.symmetric(
          horizontal: !Responsive.isMobile(context) ? kPaddingLg : kPaddingMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: kMarginMd),
          CustomTextField(
            customFocusNode: _focusNode,
            autofocus: true,
            text: 'Họ và tên học sinh',
            controller: _controller,
            onChanged: _updateHasText,
            onFieldSubmitted: (_) {
              if (_hasText) {
                context
                    .read<StudentBloc>()
                    .add(StudentCreateStarted(name: _controller.text));
              }
            },
            suffixIcon: InkWell(
              onTap: () {
                if (_hasText) {
                  context
                      .read<StudentBloc>()
                      .add(StudentCreateStarted(name: _controller.text));
                }
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

