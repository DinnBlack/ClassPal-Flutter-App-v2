import 'package:flutter/material.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../../../parent/views/parent_list_screen.dart';

class ClassConnectParentPage extends StatelessWidget {
  const ClassConnectParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: kMarginLg,
          ),
          Text(
            '56%',
            style: AppTextStyle.semibold(40, kPrimaryColor),
          ),
          const SizedBox(
            height: kMarginSm,
          ),
          Text(
            'Phụ huynh học sinh đã được kết nối',
            style: AppTextStyle.semibold(kTextSizeSm),
          ),
          const SizedBox(
            height: kMarginLg,
          ),
          const ParentListScreen(),
        ],
      ),
    );
  }
}
