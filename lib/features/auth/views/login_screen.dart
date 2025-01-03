import 'package:classpal_flutter_app/features/auth/views/register_screen.dart';
import 'package:classpal_flutter_app/features/auth/views/select_role_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'LoginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailOrPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kMarginXxl,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/classpal_logo.png',
                    width: 150,
                  ),
                ),
                const SizedBox(
                  height: kMarginXxl,
                ),
                Text(
                  'Đăng nhập tài khoản của bạn',
                  style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
                ),
                Text(
                  'Đăng nhập',
                  style: AppTextStyle.semibold(kTextSizeXxl),
                ),
                const SizedBox(
                  height: kMarginLg,
                ),

                CustomTextField(
                  text: 'Email hoặc số điện thoại',
                  controller: _emailOrPhoneNumberController,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: kMarginMd,
                ),
                CustomTextField(
                  text: 'Mật khẩu',
                  controller: _passwordController,
                  isPassword: true,
                  onChanged: (value) {},
                ),
                const SizedBox(
                  height: kMarginMd,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Mật khẩu phải có ít nhất 8 ký tự bao gồm chữ và số',
                    style: AppTextStyle.regular(kTextSizeXs),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                CustomButton(
                  text: 'Đăng nhập',
                  onTap: () {
                    Navigator.pushNamed(context, SelectRoleScreen.route);
                  },
                ),
                const SizedBox(
                  height: kMarginLg,
                ),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                      children: <TextSpan>[
                        TextSpan(text: 'Bạn chưa có tài khoản? ', style: AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
                        TextSpan(
                          text: 'Đăng ký',
                          style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(context, RegisterScreen.route);
                            },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
