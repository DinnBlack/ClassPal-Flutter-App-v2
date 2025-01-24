import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Báo cáo',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
