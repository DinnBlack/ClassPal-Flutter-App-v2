import 'package:classpal_flutter_app/features/class/models/class_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class ClassNotificationPage extends StatelessWidget {
  final ClassModel currentClass;
  const ClassNotificationPage({super.key, required this.currentClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {

    return CustomAppBar(
      backgroundColor: kWhiteColor,
      title: 'Thông báo',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
