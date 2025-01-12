import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/features/auth/views/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  static const route = 'OtpScreen';

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = kPrimaryColor;
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = kPrimaryColor;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: kMarginXxl),
              Center(
                child: Image.asset(
                  'assets/images/classpal_logo.png',
                  width: 150,
                ),
              ),
              const SizedBox(height: kMarginXxl),
              Text(
                'Đăng nhập',
                style: AppTextStyle.semibold(kTextSizeXxl),
              ),
              Text(
                'Đăng nhập tài khoản của bạn',
                style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
              ),
              const SizedBox(height: kMarginLg),
              Pinput(
                length: 6,
                // Đặt độ dài OTP là 6 ký tự
                controller: _otpController,
                focusNode: _focusNode,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.red),
                  ),
                ),
                onCompleted: (pin) {
                  print('OTP Entered: $pin');
                },
              ),
              const SizedBox(height: kMarginLg),
              CustomButton(
                text: 'Tiếp theo',
                onTap: () {
                  Navigator.pushNamed(context, ResetPasswordScreen.route, arguments: {'email': widget.email, 'otp': _otpController.text});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
