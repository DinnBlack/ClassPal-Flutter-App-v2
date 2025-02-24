import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_avatar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_list_item.dart';
import 'package:classpal_flutter_app/features/parent/models/parent_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_text_style.dart';
import '../../invitation/bloc/invitation_bloc.dart';
import '../../invitation/views/invitation_form.dart';
import '../bloc/parent_bloc.dart';

class ParentConnectListScreen extends StatefulWidget {
  const ParentConnectListScreen({super.key});

  @override
  State<ParentConnectListScreen> createState() =>
      _ParentConnectListScreenState();
}

class _ParentConnectListScreenState extends State<ParentConnectListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParentBloc>().add(ParentInvitationFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParentBloc, ParentState>(
      builder: (context, state) {
        if (state is ParentInvitationFetchInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ParentInvitationFetchSuccess) {
          int totalStudents = state.disconnectedParents.length +
              state.pendingParents.length +
              state.connectedParents.length;
          int connectedCount = state.connectedParents.length;
          double percentage = totalStudents > 0
              ? (connectedCount / totalStudents) * 100
              : 0;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kMarginXl,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: AppTextStyle.semibold(40, kPrimaryColor),
                    ),
                  ),
                  const SizedBox(
                    height: kMarginSm,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Phụ huynh học sinh đã được kết nối',
                      style: AppTextStyle.semibold(kTextSizeSm),
                    ),
                  ),
                  const SizedBox(
                    height: kMarginXl,
                  ),
                  _buildParentList('Chưa kết nối', state.disconnectedParents,
                      'Mời', _showInviteDialog),
                  const SizedBox(height: kMarginLg),
                  _buildParentList(
                      'Đang chờ', state.pendingParents, 'Xóa', _showDeleteDialog),
                  const SizedBox(height: kMarginLg),
                  _buildParentList('Đã kết nối', state.connectedParents, 'Xóa',
                      _showDeleteDialog),
                ],
              ),
            ),
          );
        } else if (state is ParentInvitationFetchFailure) {
          return Center(child: Text("Lỗi: ${state.error}"));
        }
        return const SizedBox();
      },
    );
  }

  void _showInviteDialog(BuildContext context,
      ParentInvitationModel parentInvitation, String name) {
    showInvitationForm(context, parentInvitation, 'Parent', name);
  }

  void _showDeleteDialog(BuildContext context,
      ParentInvitationModel parentInvitation, String name) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content:
              Text('Bạn có chắc chắn muốn xóa $name khỏi danh sách không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<ParentBloc>()
                    .add(ParentDeleteStarted(parentInvitation.parentId!));
                context.read<InvitationBloc>().add(
                    InvitationRemoveStarted(email: parentInvitation.email!));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Có', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParentList(
    String title,
    List<ParentInvitationModel> parents,
    String actionText,
    Function(BuildContext, ParentInvitationModel, String)? onActionTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title (${parents.length})',
          style: AppTextStyle.semibold(kTextSizeMd),
        ),
        const SizedBox(height: kMarginLg),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: parents.length,
          itemBuilder: (context, index) {
            final parent = parents[index];
            return Column(
              children: [
                CustomListItem(
                  title: 'p/h của ${parent.studentName}',
                  subtitle: parent.email,
                  leading: const CustomAvatar(
                      imageAsset: 'assets/images/parent.jpg'),
                  onTap: () {
                    if (onActionTap != null) {
                      onActionTap(context, parent, parent.studentName);
                    }
                  },
                  trailing: InkWell(
                    onTap: () {
                      if (onActionTap != null) {
                        onActionTap(context, parent, parent.studentName);
                      }
                    },
                    child: Text(
                      actionText,
                      style: AppTextStyle.medium(
                        kTextSizeSm,
                        actionText == 'Mời' ? kPrimaryColor : kRedColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ],
    );
  }
}
