import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';

class CountdownTimerScreen extends StatefulWidget {
  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  final List<int> presetTimes = [10, 30, 60, 120]; // Giây
  int? selectedTime;
  Timer? _timer;
  int _remainingTime = 0;
  bool isRunning = false;

  void startTimer() {
    if (_remainingTime > 0) {
      setState(() => isRunning = true);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() => _remainingTime--);
        } else {
          timer.cancel();
          setState(() => isRunning = false);

          // Phát chuông báo động khi hết thời gian
          FlutterRingtonePlayer().playAlarm(asAlarm: true);

          // Hiển thị thông báo hết thời gian
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("⏰ Hết thời gian!",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text("Bạn đã hoàn thành bộ đếm ngược."),
              actions: [
                TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer().stop();
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    stopTimer();
    setState(() => _remainingTime = selectedTime ?? 0);
  }

  void addTime(int seconds) {
    setState(() => _remainingTime += seconds);
  }

  void selectTime(int seconds) {
    setState(() {
      selectedTime = seconds;
      _remainingTime = seconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kIsWeb ? kTransparentColor : kBackgroundColor,
      appBar: _buildAppBar(context),
      body: Padding(
        padding:  const EdgeInsets.symmetric(horizontal: kPaddingMd),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             const SizedBox(height: kMarginLg),
            Wrap(
              spacing: 12,
              children: presetTimes.map((time) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTime == time
                        ? kPrimaryColor
                        : Colors.grey.shade300,
                    foregroundColor:
                        selectedTime == time ? Colors.white : Colors.black,
                  ),
                  onPressed: () => selectTime(time),
                  child: Text("${time}s"),
                );
              }).toList(),
            ),
            const SizedBox(height: kMarginLg),
            Text(
              "${_remainingTime}s",
              style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            const SizedBox(height: kMarginLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(
                    isRunning ? Icons.pause : Icons.play_arrow,
                    color: kWhiteColor,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Colors.orange : Colors.green,
                  ),
                  onPressed: isRunning ? stopTimer : startTimer,
                  label: Text(
                    isRunning ? "Dừng" : "Bắt đầu",
                    style: AppTextStyle.semibold(kTextSizeSm, kWhiteColor),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.replay,
                    color: kWhiteColor,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: resetTimer,
                  label: Text(
                    "Đặt lại",
                    style: AppTextStyle.semibold(kTextSizeSm, kWhiteColor),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add, color: kWhiteColor,),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor),
                  onPressed: () => addTime(10),
                  label: Text(
                    "+10s",
                    style: AppTextStyle.semibold(kTextSizeSm, kWhiteColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Đếm thời gian',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
