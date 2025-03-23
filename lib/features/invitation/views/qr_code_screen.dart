import 'dart:async';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../student/bloc/student_bloc.dart';

class QRCodeScreen extends StatefulWidget {
  final String code;

  const QRCodeScreen({Key? key, required this.code}) : super(key: key);

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late Timer _timer;
  int _remainingSeconds = 300; // 5 phút = 300 giây

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
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
            QrImageView(
              data: widget.code,
              size: 200,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: kMarginMd),
            Text(
              'Mã QR hết hạn sau:',
              style: AppTextStyle.medium(kTextSizeSm, kGreyColor),
            ),
            const SizedBox(height: kMarginSm),
            Text(
              _formatTime(_remainingSeconds),
              style: AppTextStyle.bold(24, Colors.red),
            ),
            const SizedBox(height: kMarginMd),
            Text(
              'Hoặc',
              style: AppTextStyle.medium(kTextSizeSm, kGreyColor),
            ),
            const SizedBox(height: kMarginLg),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: kMarginLg),
              padding: const EdgeInsets.symmetric(
                  horizontal: kPaddingLg, vertical: kPaddingMd),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadiusXl),
                color: kPrimaryColor,
              ),
              child: Text(
                widget.code,
                style: AppTextStyle.bold(kTextSizeLg, kWhiteColor),
              ),
            ),
            const SizedBox(height: kMarginLg),
            Text(
              'Hướng dẫn tham gia',
              style: AppTextStyle.semibold(kTextSizeSm),
            ),
            const SizedBox(height: kMarginMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '1. Mở ứng dụng ',
                    style: AppTextStyle.regular(kTextSizeXs),
                    children: [
                      TextSpan(
                        text: 'ClassPal',
                        style: AppTextStyle.bold(kTextSizeXs)
                            .copyWith(color: kPrimaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMarginSm),
                Text.rich(
                  TextSpan(
                    text: '2. Đăng nhập và chọn ',
                    style: AppTextStyle.regular(kTextSizeXs),
                    children: [
                      TextSpan(
                        text: 'quyền học sinh',
                        style: AppTextStyle.bold(kTextSizeXs),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMarginSm),
                Text(
                  '3. Quét mã QR hoặc nhập mã để tham gia',
                  style: AppTextStyle.regular(kTextSizeXs),
                ),
                const SizedBox(height: 50),
              ],
            )
          ],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Mã lớp học',
      leftWidget: InkWell(
        onTap: () {
          context.read<StudentBloc>().add(StudentFetchStarted());
          Navigator.pop(context);
        },
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
      ),
    );
  }
}
