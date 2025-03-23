import 'dart:async';
import 'dart:math';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../profile/model/profile_model.dart';

class RandomStudentPickerScreen extends StatefulWidget {
  final List<ProfileModel> students;

  const RandomStudentPickerScreen({super.key, required this.students});

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
  List<ProfileModel> _remainingStudents = [];
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _remainingStudents = List.from(widget.students);
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _startRandomizingOnOpen();
  }

  void _startRandomizingOnOpen() {
    if (_remainingStudents.isEmpty) return;
    isRandomizing = true;
    _startRandomEffect().then((_) {
      _showRemoveDialog();
    });
  }

  /// Tạo hiệu ứng vòng quay chậm dần
  Future<void> _startRandomEffect() async {
    int duration = 50; // Bắt đầu với tốc độ cao (50ms)
    isRandomizing = true;
    _rotationController.repeat();

    _timer = Timer.periodic(Duration(milliseconds: duration), (timer) {
      setState(() {
        selectedStudent = _remainingStudents[_random.nextInt(_remainingStudents.length)];
      });

      if (duration < 300) {
        duration += 20; // Tăng thời gian để hiệu ứng chậm dần
        timer.cancel();
        _timer = Timer.periodic(Duration(milliseconds: duration), (t) {
          setState(() {
            selectedStudent = _remainingStudents[_random.nextInt(_remainingStudents.length)];
          });

          if (duration >= 300) {
            t.cancel();
            _rotationController.stop();
            setState(() => isRandomizing = false);
          }
        });
      }
    });

    await Future.delayed(Duration(milliseconds: 3000)); // Tổng thời gian random
    _timer?.cancel();
    _rotationController.stop();
    setState(() => isRandomizing = false);
  }

  /// Hỏi người dùng có muốn giữ lại học sinh hay không
  void _showRemoveDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Xóa học sinh khỏi danh sách?"),
          content: Text("Bạn có muốn xóa ${selectedStudent.displayName} khỏi danh sách?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Giữ lại học sinh
              },
              child: const Text("Giữ lại"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _remainingStudents.remove(selectedStudent);
                });
                Navigator.pop(context);
              },
              child: const Text("Xóa"),
            ),
          ],
        );
      },
    );
  }

  void startRandomizing() {
    if (isRandomizing || _remainingStudents.isEmpty) return;
    _startRandomEffect().then((_) {
      _showRemoveDialog();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !Responsive.isMobile(context) ? kTransparentColor : kBackgroundColor,
      appBar: _buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: Column(
                key: ValueKey(selectedStudent.displayName),
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: Container(
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
                        backgroundColor: kPrimaryColor,
                        radius: 70,
                        backgroundImage: NetworkImage(selectedStudent.avatarUrl),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    selectedStudent.displayName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
              child: CustomButton(
                text: isRandomizing ? 'Đang chọn...' : 'Chọn lại',
                icon: Icons.shuffle,
                isValid: !isRandomizing,
                onTap: !isRandomizing ? startRandomizing : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Ngẫu nhiên',
      leftWidget: InkWell(
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
