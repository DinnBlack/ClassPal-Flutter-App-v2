import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';

class SchoolStoryPage extends StatelessWidget {
  const SchoolStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Trường tiểu học A Long Bình',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      rightWidget: InkWell(
        child: const Icon(FontAwesomeIcons.ellipsis),
        onTap: () {
        },
      ),
    );
  }
}
