import 'dart:async';
import 'dart:math';

import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';

import '../../profile/model/profile_model.dart';

class RandomStudentPickerScreen extends StatefulWidget {
  final List<ProfileModel> students;

  RandomStudentPickerScreen({required this.students});

  @override
  _RandomStudentPickerScreenState createState() =>
      _RandomStudentPickerScreenState();
}

class _RandomStudentPickerScreenState extends State<RandomStudentPickerScreen>
    with SingleTickerProviderStateMixin {
  late ProfileModel selectedStudent;
  Timer? _timer;
  bool isRandomizing = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    selectedStudent = widget.students[_random.nextInt(widget.students.length)];
    _startRandomizingOnOpen();
  }

  void _startRandomizingOnOpen() {
    isRandomizing = true;
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        selectedStudent =
            widget.students[_random.nextInt(widget.students.length)];
      });
    });

    Future.delayed(Duration(milliseconds: 2000 + _random.nextInt(2000)), () {
      _timer?.cancel();
      setState(() => isRandomizing = false);
    });
  }

  void startRandomizing() {
    if (isRandomizing) return;
    setState(() => isRandomizing = true);

    _timer = Timer.periodic(Duration(milliseconds: 80), (timer) {
      setState(() {
        selectedStudent =
            widget.students[_random.nextInt(widget.students.length)];
      });
    });

    Future.delayed(Duration(milliseconds: 2000 + _random.nextInt(2000)), () {
      _timer?.cancel();
      setState(() => isRandomizing = false);
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
        title: Text("🎲 Chọn Học Sinh Ngẫu Nhiên"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Column(
                key: ValueKey(selectedStudent.displayName),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(selectedStudent.avatarUrl),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    selectedStudent.displayName,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: startRandomizing,
              icon: Icon(Icons.shuffle, color: kWhiteColor,),
              label: Text(
                isRandomizing ? "Đang chọn..." : "Chọn lại",
                style: AppTextStyle.semibold(kTextSizeMd, kWhiteColor),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: AppTextStyle.semibold(kTextSizeMd, kWhiteColor),
                backgroundColor:
                    isRandomizing ? Colors.grey : Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
