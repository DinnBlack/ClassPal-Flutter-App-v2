import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/class/sub_features/schedule/views/schedule_create_screen.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/config/app_constants.dart';
import '../../models/class_model.dart';
import '../../sub_features/schedule/views/schedule_list_screen.dart';

class ClassSchedulePage extends StatefulWidget {
  final ClassModel currentClass;

  const ClassSchedulePage({super.key, required this.currentClass});

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          EasyDateTimeLinePicker(
            currentDate: selectedDate,
            focusedDate: DateTime.now(),
            firstDate: DateTime(2024, 1, 1),
            lastDate: DateTime(2030, 1, 1),
            locale: const Locale('vi'),
            onDateChange: (date) {
              setState(() {
                selectedDate = date;
              });
            },
          ),
          const SizedBox(height: kMarginMd),
          Text(
            'Lịch học của bạn',
            style: AppTextStyle.semibold(kTextSizeSm),
          ),
          const SizedBox(height: kMarginMd),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
              child: ScheduleListScreen(selectedDate: selectedDate),
            ),
          ),
        ],
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Lịch học',
      leftWidget: InkWell(
        child: const Icon(FontAwesomeIcons.arrowLeft),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      rightWidget: GestureDetector(
        child: Text(
          'Tạo lịch',
          style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
        ),
        onTap: () {
          CustomPageTransition.navigateTo(
              context: context,
              page: const ScheduleCreateScreen(),
              transitionType: PageTransitionType.slideFromBottom);
        },
      ),
    );
  }
}
