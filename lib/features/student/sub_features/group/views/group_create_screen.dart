import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../views/student_list_screen.dart';
import '../bloc/group_bloc.dart';

class GroupCreateScreen extends StatefulWidget {
  static const route = 'GroupCreateScreen';

  const GroupCreateScreen({super.key});

  @override
  _GroupCreateScreenState createState() => _GroupCreateScreenState();
}

class _GroupCreateScreenState extends State<GroupCreateScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> studentIds = [];
  bool _hasText = false;

  void _updateHasText(String value) {
    setState(() {
      _hasText = value.isNotEmpty;
    });
  }

  void _onStudentsSelected(List<String> selectedIds) {
    setState(() {
      studentIds.clear();
      studentIds.addAll(selectedIds);
    });
  }

  void _createGroup(BuildContext context) {
    if (_controller.text.isEmpty || studentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng nhập tên nhóm và chọn học sinh')),
      );
      return;
    }

    context.read<GroupBloc>().add(
          GroupCreateStarted(name: _controller.text, studentIds: studentIds),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupCreateInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is GroupCreateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo nhóm thành công')),
          );
          Navigator.pop(context);
        } else if (state is GroupCreateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo nhóm thất bại')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kMarginMd),
            CustomTextField(
              text: 'Tên nhóm',
              controller: _controller,
              onChanged: _updateHasText,
              suffixIcon: InkWell(
                onTap: () => _createGroup(context),
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
            const SizedBox(height: kMarginLg),
            StudentListScreen(
              onSelectionChanged: _onStudentsSelected,
              isPickerView: true,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thêm nhóm',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
