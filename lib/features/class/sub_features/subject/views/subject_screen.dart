import 'package:classpal_flutter_app/features/class/sub_features/subject/views/subject_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../bloc/subject_bloc.dart';

class SubjectScreen extends StatelessWidget {
  const SubjectScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocListener<SubjectBloc, SubjectState>(
        listener: (context, state) {
          if (state is SubjectFetchInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }
        },
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return const SubjectListScreen();
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Thông tin lớp học',
      leftWidget: InkWell(
        onTap: () => Navigator.pop(context),
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
      ),
    );
  }
}
