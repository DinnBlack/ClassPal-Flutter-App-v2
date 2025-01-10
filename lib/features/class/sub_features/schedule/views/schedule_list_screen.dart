import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/class/sub_features/schedule/views/widgets/custom_schedule_list_item.dart';
import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../repository/schedule_data.dart';

class ScheduleListScreen extends StatelessWidget {
  final DateTime selectedDate;

  const ScheduleListScreen({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    List<ScheduleModel> filteredSchedules = schedules.where((schedule) {
      if (schedule.repeatType == RepeatType.none) {
        return schedule.startDate.isSameDate(selectedDate);
      }

      DateTime currentDate = schedule.startDate;
      while (currentDate.isBefore(schedule.repeatEndDate!)) {
        if (schedule.repeatType == RepeatType.daily) {
          if (currentDate.isSameDate(selectedDate)) {
            return true;
          }
        } else if (schedule.repeatType == RepeatType.weekly) {
          if (currentDate.isSameDate(selectedDate) ||
              (currentDate.weekday == selectedDate.weekday &&
                  currentDate.isBefore(schedule.repeatEndDate!))) {
            return true;
          }
        } else if (schedule.repeatType == RepeatType.monthly) {
          if (currentDate.day == selectedDate.day &&
              currentDate.month == selectedDate.month &&
              currentDate.year == selectedDate.year) {
            return true;
          }
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
      return false;
    }).toList();

    filteredSchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

    return filteredSchedules.isEmpty
        ? const Center(child: Text('Không có lịch cho ngày này.'))
        : ListView.builder(
      shrinkWrap: true,
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        final schedule = filteredSchedules[index];
        return Column(
          children: [
            CustomScheduleListItem(schedule: schedule),
            const SizedBox(height: kMarginMd),
          ],
        );
      },
    );
  }
}

// Extension để so sánh ngày
extension DateTimeComparison on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
