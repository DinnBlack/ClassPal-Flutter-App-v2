import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_with_students_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../views/student_list_screen.dart';
import '../bloc/group_bloc.dart';

class GroupEditScreen extends StatefulWidget {
  final GroupWithStudentsModel groupWithStudents;

  const GroupEditScreen({super.key, required this.groupWithStudents});

  @override
  _GroupEditScreenState createState() => _GroupEditScreenState();
}

class _GroupEditScreenState extends State<GroupEditScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _selectedStudentIds = [];
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.groupWithStudents.group.name;
    _selectedStudentIds
        .addAll(widget.groupWithStudents.students.map((s) => s.id).toList());

    _controller.addListener(_checkChanges);
  }

  void _checkChanges() {
    final bool isNameChanged =
        _controller.text != widget.groupWithStudents.group.name;
    final Set<String> initialStudentIds =
        widget.groupWithStudents.students.map((s) => s.id).toSet();
    final Set<String> newStudentIds = _selectedStudentIds.toSet();

    final bool isStudentsChanged = initialStudentIds != newStudentIds;

    setState(() {
      _isChanged = isNameChanged || isStudentsChanged;
    });
  }

  void _onStudentsSelected(List<String> selectedIds) {
    setState(() {
      _selectedStudentIds.clear();
      _selectedStudentIds.addAll(selectedIds);
      _checkChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupUpdateInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is GroupUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật Thành công')),
          );
          Navigator.pop(context);
        } else if (state is GroupUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thất bại')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kIsWeb ? kTransparentColor : kBackgroundColor,
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
              onChanged: (value) => _checkChanges(),
            ),
            const SizedBox(height: kMarginLg),
            StudentListScreen(
              onSelectionChanged: _onStudentsSelected,
              isPickerView: true,
              studentsInGroup: widget.groupWithStudents.students,
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Chỉnh sửa nhóm',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: InkWell(
        onTap: _isChanged ? () => _onUpdateGroup(context) : null,
        child: Icon(
          FontAwesomeIcons.check,
          color: _isChanged ? kPrimaryColor : Colors.grey,
        ),
      ),
    );
  }

  void _onUpdateGroup(BuildContext context) {
    final String newName = _controller.text;
    final String initialName = widget.groupWithStudents.group.name;
    final List<String> initialStudentIds =
        widget.groupWithStudents.students.map((s) => s.id).toList();
    final Set<String> newStudentIds = _selectedStudentIds.toSet();

    final String? updatedName = (newName != initialName) ? newName : null;
    final List<String>? updatedStudentIds =
        (newStudentIds != initialStudentIds) ? _selectedStudentIds : null;

    context.read<GroupBloc>().add(
          GroupUpdateStarted(widget.groupWithStudents,
              name: updatedName, studentIds: updatedStudentIds),
        );
  }
}
