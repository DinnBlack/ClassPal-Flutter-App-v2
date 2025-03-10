import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/views/reset_password_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';

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
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final isOtpValid = Validators.validateOtp(_otpController.text) == null;

      _isValid = isOtpValid && _otpController.text.trim().isNotEmpty;
    });
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
        borderRadius: BorderRadius.circular(kBorderRadiusSm),
        border: Border.all(color: borderColor),
      ),
    );
    void submitOtp() {
      if (_isValid) {
        CustomPageTransition.navigateTo(
          context: context,
          page: ResetPasswordScreen(
            email: widget.email,
            otp: _otpController.text,
          ),
          transitionType: PageTransitionType.slideFromRight,
        );
      }
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(
        leftWidget: InkWell(
          child: const Icon(FontAwesomeIcons.arrowLeft),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Xác thực',
                  style: AppTextStyle.bold(kTextSizeXl),
                ),
                const SizedBox(height: kMarginSm),
                Text(
                  'Nhập mã otp đã gửi vào email của bạn',
                  style: AppTextStyle.medium(kTextSizeXs),
                ),
                const SizedBox(height: kMarginLg),
                Pinput(
                  length: 6,
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
                    submitOtp(); // Gọi hàm xử lý OTP khi nhập đủ
                  },
                  onSubmitted: (pin) {
                    submitOtp(); // Gọi hàm xử lý khi nhấn Enter
                  },
                ),
                const SizedBox(height: kMarginLg),
                CustomButton(
                  text: 'Tiếp theo',
                  isValid: _isValid,
                  onTap: _isValid
                      ? () {
                          if (kIsWeb) {
                            GoRouter.of(context).push('/auth/reset-password',
                                extra: {
                                  'email': widget.email,
                                  'otp': _otpController.text
                                });
                          } else {
                            CustomPageTransition.navigateTo(
                                context: context,
                                page: ResetPasswordScreen(
                                  email: widget.email,
                                  otp: _otpController.text,
                                ),
                                transitionType:
                                    PageTransitionType.slideFromRight);
                          }
                        }
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
