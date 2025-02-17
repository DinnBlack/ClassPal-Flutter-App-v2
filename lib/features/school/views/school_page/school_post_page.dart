import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/features/post/views/post_list_screen.dart';
import 'package:classpal_flutter_app/features/school/models/school_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../class/bloc/class_bloc.dart';

class SchoolPostPage extends StatelessWidget {
  final SchoolModel school;

  const SchoolPostPage({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: const Expanded(child: PostListScreen()),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: school.name,
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          context.read<ClassBloc>().add(ClassPersonalFetchStarted());
          Navigator.pop(context);
        },
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {},
      ),
    );
  }
}
