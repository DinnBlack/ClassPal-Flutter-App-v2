import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/student/sub_features/group/model/group_with_students_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_feature_dialog.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../views/student_list_screen.dart';
import '../bloc/group_bloc.dart';
import 'group_edit_screen.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupWithStudentsModel groupWithStudents;

  const GroupDetailScreen({super.key, required this.groupWithStudents});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      [
        'Chỉnh sửa nhóm',
        'Xóa nhóm',
      ],
      [
        () {
          if (kIsWeb) {
            showCustomDialog(
              context,
              GroupEditScreen(
                groupWithStudents: widget.groupWithStudents,
              ),
            );
          } else {
            CustomPageTransition.navigateTo(
                context: context,
                page: GroupEditScreen(
                  groupWithStudents: widget.groupWithStudents,
                ),
                transitionType: PageTransitionType.slideFromBottom);
          }
        },
        () {
          _showDeleteConfirmationDialog(context);
        },
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc chắn muốn xóa nhóm này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context
                  .read<GroupBloc>()
                  .add(GroupDeleteStarted(widget.groupWithStudents.group.id));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is GroupDeleteInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is GroupDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa nhóm thành công')),
          );
          Navigator.pop(context);
        } else if (state is GroupDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa nhóm thất bại')),
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

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: widget.groupWithStudents.group.name,
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

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: kMarginMd),
            StudentListScreen(
              studentsInGroup: widget.groupWithStudents.students,
            ),
          ],
        ),
      ),
    );
  }
}
