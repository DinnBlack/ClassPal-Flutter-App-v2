import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_text_style.dart';
import '../../student/views/student_attendance_list_screen.dart';

class ClassAttendanceScreen extends StatelessWidget {
  const ClassAttendanceScreen({super.key});

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("EEEE, 'ngày' d 'tháng' M").format(now);
    return formattedDate
        .replaceFirst('Monday', 'Thứ 2')
        .replaceFirst('Tuesday', 'Thứ 3')
        .replaceFirst('Wednesday', 'Thứ 4')
        .replaceFirst('Thursday', 'Thứ 5')
        .replaceFirst('Friday', 'Thứ 6')
        .replaceFirst('Saturday', 'Thứ 7')
        .replaceFirst('Sunday', 'Chủ Nhật');
  }

  Widget _buildAttendanceCard(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: kPaddingLg),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(kBorderRadiusMd),
          border: Border.all(width: 2, color: kGreyMediumColor),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: AppTextStyle.semibold(kTextSizeMd, kGreyColor)),
            Text(count, style: AppTextStyle.semibold(kTextSizeXxl, color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: kMarginXl),
            Text(
              _getFormattedDate(),
              style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
            ),
            const SizedBox(height: kMarginMd),
            Row(
              children: [
                _buildAttendanceCard('Đi học', '12', kPrimaryColor),
                const SizedBox(width: kMarginLg),
                _buildAttendanceCard('Vắng', '2', kRedColor),
                const SizedBox(width: kMarginLg),
                _buildAttendanceCard('Đi trễ', '1', kOrangeColor),
              ],
            ),
            const SizedBox(height: kMarginMd),
            const CustomButton(text: 'Đánh dấu cả lớp có mặt'),
            const SizedBox(height: kMarginXl),
            const StudentAttendanceListScreen(),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Điểm danh',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark, color: kGreyColor),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: Text(
        'Lưu',
        style: AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
      ),
    );
  }
}
