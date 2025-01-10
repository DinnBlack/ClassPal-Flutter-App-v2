import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/app_text_style.dart';
import '../../../../../core/widgets/custom_app_bar.dart';

class ScheduleCreateScreen extends StatefulWidget {
  const ScheduleCreateScreen({super.key});

  @override
  State<ScheduleCreateScreen> createState() => _ScheduleCreateScreenState();
}

class _ScheduleCreateScreenState extends State<ScheduleCreateScreen> {
  Color selectedColor = Colors.blue;
  final List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTransparentColor,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          children: [
            const SizedBox(height: kMarginLg),
            const CustomTextField(text: 'Tiêu đề'),
            const SizedBox(height: kMarginLg),
            const CustomTextField(text: 'Ghi chú'),
            const SizedBox(height: kMarginLg),
            CustomTextField(
              text: 'Ngày tháng',
              defaultValue: DateFormat("d/M/y").format(DateTime.now()),
              isDatePicker: true,
              suffixIcon: const Icon(
                FontAwesomeIcons.calendarDays,
                color: kGreyColor,
                size: 20,
              ),
            ),
            const SizedBox(height: kMarginLg),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    text: 'Bắt đầu',
                    defaultValue: DateFormat("HH:mm").format(DateTime.now()),
                    isTimePicker: true,
                    suffixIcon: const Icon(
                      FontAwesomeIcons.clockFour,
                      color: kGreyColor,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: kMarginLg),
                Expanded(
                  child: CustomTextField(
                    text: 'Kết thúc',
                    defaultValue: DateFormat("HH:mm").format(DateTime.now()),
                    isTimePicker: true,
                    suffixIcon: const Icon(
                      FontAwesomeIcons.clockFour,
                      color: kGreyColor,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: kMarginLg),
            const CustomTextField(
              text: 'Lặp lại',
              options: ['Không', 'Mỗi ngày', 'Mỗi tuần', 'Mỗi tháng'],
            ),
            const SizedBox(height: kMarginLg),
            _buildHorizontalColorPicker(),
            const SizedBox(height: kMarginLg),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalColorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn màu:',
          style: AppTextStyle.medium(
            kTextSizeMd,
          ),
        ),
        const SizedBox(height: kMarginMd),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: colorOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final color = colorOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    if (selectedColor == color)
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Tạo lịch học',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.xmark),
        onTap: () => Navigator.pop(context),
      ),
      rightWidget: GestureDetector(
        child: Text(
          'Tạo',
          style: AppTextStyle.semibold(kTextSizeMd, kPrimaryColor),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
