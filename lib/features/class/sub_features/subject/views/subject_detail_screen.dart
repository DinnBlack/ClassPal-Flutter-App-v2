import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_dialog.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/models/subject_model.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/views/subject_edit_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_feature_dialog.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../../../../../core/widgets/custom_page_transition.dart';
import '../../grade/views/grade_list_screen.dart';
import '../bloc/subject_bloc.dart';

class SubjectDetailScreen extends StatefulWidget {
  final SubjectModel subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  SubjectModel? _subject;

  @override
  void initState() {
    super.initState();
    _subject = widget.subject;
  }

  void _showFeatureDialog(BuildContext context) {
    showCustomFeatureDialog(
      context,
      ['Chỉnh sửa môn học', 'Xóa môn học'],
      [
        () {
          if (kIsWeb) {
            showCustomDialog(
              context,
              SubjectEditScreen(subject: _subject ?? widget.subject),
            );
          } else {
            CustomPageTransition.navigateTo(
              context: context,
              page: SubjectEditScreen(subject: _subject ?? widget.subject),
              transitionType: PageTransitionType.slideFromBottom,
            );
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
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text(
              'Bạn có chắc chắn muốn xóa môn học này? Dữ liệu sẽ không thể khôi phục.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<SubjectBloc>()
                    .add(SubjectDeleteStarted(widget.subject.id));
                Navigator.pop(context);
              },
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubjectBloc, SubjectState>(
      listener: (context, state) {
        if (state is SubjectDeleteInProgress) {
          CustomLoadingDialog.show(context);
        } else {
          CustomLoadingDialog.dismiss(context);
        }

        if (state is SubjectDeleteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa môn học thành công')),
          );
          Navigator.pop(context);
        }
        if (state is SubjectDeleteFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa môn học thất bại')),
          );
        }

        if (state is SubjectFetchByIdSuccess) {
          setState(() {
            _subject = state.subject;
          });
        }
        if (state is SubjectFetchByIdFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fetch subject thất bại')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: kIsWeb ? kTransparentColor : kBackgroundColor,
        appBar: _buildAppBar(context),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kIsWeb ? kPaddingLg : kPaddingMd),
      child: GradeListScreen(
        subject: _subject!,
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: _subject?.name ?? widget.subject.name,
      leftWidget: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
            kIsWeb ? FontAwesomeIcons.xmark : FontAwesomeIcons.arrowLeft),
      ),
      rightWidget: InkWell(
        onTap: () => _showFeatureDialog(context),
        child: const Icon(FontAwesomeIcons.ellipsis),
      ),
    );
  }
}
