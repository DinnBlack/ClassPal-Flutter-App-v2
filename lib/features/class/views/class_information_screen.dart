import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClassInformationScreen extends StatelessWidget {
  const ClassInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor,
              border: Border.all(width: 2, color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar() {
    return const CustomAppBar(
      title: 'Thông tin lớp học',
      leftWidget: InkWell(
        child: Icon(
          FontAwesomeIcons.xmark,
          color: kGreyColor,
        ),
      ),
    );
  }
}
