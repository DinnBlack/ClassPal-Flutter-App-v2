import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/class/sub_features/roll_call/models/roll_call_session_model.dart';
import 'package:classpal_flutter_app/features/student/views/student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/widgets/custom_loading_dialog.dart';
import '../bloc/roll_call_bloc.dart';
import '../repository/roll_call_service.dart';

class RollCallScreen extends StatefulWidget {
  const RollCallScreen({super.key});

  @override
  State<RollCallScreen> createState() => _RollCallScreenState();
}

class _RollCallScreenState extends State<RollCallScreen> {
  Map<String, int> rollCallStatus = {};

  int get countPresent => rollCallStatus.values.where((v) => v == 0).length;

  int get countAbsent => rollCallStatus.values.where((v) => v == 1).length;

  int get countLate => rollCallStatus.values.where((v) => v == 2).length;

  @override
  void initState() {
    super.initState();
    rollCallStatus = {};
  }

  void _updateAttendance(List<Map<String, int>> statusList) {
    setState(() {
      rollCallStatus = {
        for (var entry in statusList) entry.keys.first: entry.values.first
      };
    });
  }

  void saveRollCall() {
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<Map<String, int>> studentsRollCall = rollCallStatus.entries
        .map((entry) => {entry.key: entry.value})
        .toList();

    context.read<RollCallBloc>().add(
          RollCallCreateStarted(date: date, studentsRollCall: studentsRollCall),
        );
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    return DateFormat("EEEE, 'ngày' d 'tháng' M")
        .format(now)
        .replaceFirst('Monday', 'Thứ 2')
        .replaceFirst('Tuesday', 'Thứ 3')
        .replaceFirst('Wednesday', 'Thứ 4')
        .replaceFirst('Thursday', 'Thứ 5')
        .replaceFirst('Friday', 'Thứ 6')
        .replaceFirst('Saturday', 'Thứ 7')
        .replaceFirst('Sunday', 'Chủ Nhật');
  }

  Widget _buildAttendanceCard(String label, int count, Color color) {
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
            Text('$count', style: AppTextStyle.semibold(kTextSizeXxl, color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocConsumer<RollCallBloc, RollCallState>(
        listener: (context, state) {
          if (state is RollCallCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          if (state is RollCallCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo điểm danh thành công')),
            );
            Navigator.pop(context);
          } else if (state is RollCallCreateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tạo điểm danh thất bại')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: kMarginLg),
                Text(_getFormattedDate(),
                    style: AppTextStyle.bold(kTextSizeMd)),
                const SizedBox(height: kMarginMd),
                Row(
                  children: [
                    _buildAttendanceCard('Đi học', countPresent, kPrimaryColor),
                    const SizedBox(width: kMarginLg),
                    _buildAttendanceCard('Vắng', countAbsent, kRedColor),
                    const SizedBox(width: kMarginLg),
                    _buildAttendanceCard('Đi trễ', countLate, kOrangeColor),
                  ],
                ),
                const SizedBox(height: kMarginMd),
                CustomButton(
                  text: 'Đánh dấu cả lớp có mặt',
                  isValid: rollCallStatus.values.any((status) => status != 0),
                  onTap: () async {
                    setState(() {
                      rollCallStatus.updateAll((key, value) => 0);
                      _updateAttendance(
                        rollCallStatus.entries.map((entry) => {entry.key: entry.value}).toList(),
                      );
                    });

                    RollCallSessionModel? rollCallSession =
                        await RollCallService().getRollCallSessionToday();
                    if (rollCallSession != null) {
                      await RollCallService()
                          .getRollCallEntriesBySessionId(rollCallSession.id);
                    }
                  },
                ),
                const SizedBox(height: kMarginXl),
                StudentListScreen(
                  isRollCallView: true,
                  onStatusChanged: (statusList) {
                    setState(() {
                      _updateAttendance(statusList);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Điểm danh',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: InkWell(
        onTap: saveRollCall,
        child: Text(
          'Lưu',
          style: AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
        ),
      ),
    );
  }
}
