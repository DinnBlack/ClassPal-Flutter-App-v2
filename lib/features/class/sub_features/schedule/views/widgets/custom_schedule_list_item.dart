import 'package:flutter/material.dart';
import '../../../../../../core/config/app_constants.dart';
import '../../models/schedule_model.dart';
import 'package:intl/intl.dart';

class CustomScheduleListItem extends StatefulWidget {
  final ScheduleModel schedule;

  const CustomScheduleListItem({
    super.key,
    required this.schedule,
  });

  @override
  State<CustomScheduleListItem> createState() => _CustomScheduleListItemState();
}

class _CustomScheduleListItemState extends State<CustomScheduleListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
      duration: const Duration(milliseconds: 100),
    )..value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _controller.reverse();
        _controller.forward();
      },
      child: ScaleTransition(
        scale: _controller,
        child: Stack(
          children: [
            Container(
              height: 105,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${widget.schedule.color.substring(1)}'))
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Color(int.parse('0xFF${widget.schedule.color.substring(1)}')),
                borderRadius: BorderRadius.circular(kBorderRadiusMd),
              ),
              padding: const EdgeInsets.all(kMarginSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.schedule.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.schedule.note,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the left and right
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: kGreyMediumColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${DateFormat('HH:mm').format(widget.schedule.startTime)} - ${DateFormat('HH:mm').format(widget.schedule.endTime)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: kGreyMediumColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
