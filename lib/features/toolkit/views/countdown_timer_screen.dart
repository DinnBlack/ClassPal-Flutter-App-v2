import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

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
              title: Text("⏰ Hết thời gian!",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Text("Bạn đã hoàn thành bộ đếm ngược."),
              actions: [
                TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer().stop();
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
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
      appBar: AppBar(
        title: Text("⏳ Bộ Đếm Ngược"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Chọn thời gian:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: presetTimes.map((time) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedTime == time
                        ? Colors.blue
                        : Colors.grey.shade300,
                    foregroundColor:
                        selectedTime == time ? Colors.white : Colors.black,
                  ),
                  onPressed: () => selectTime(time),
                  child: Text("${time}s"),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Text("Thời gian còn lại:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            SizedBox(height: 10),
            Text(
              "${_remainingTime}s",
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
            SizedBox(height: 30),
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
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(
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
                SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.add, color: kWhiteColor,),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
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
}
