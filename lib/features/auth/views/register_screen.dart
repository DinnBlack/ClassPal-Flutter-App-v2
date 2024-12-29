import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  static const route = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                const SizedBox(height: kMarginXxl),
                Center(
                  child: Image.asset(
                    'assets/images/classpal_logo.png',
                    width: 150,
                  ),
                ),
                const SizedBox(height: kMarginXxl),
                Text(
                  'Tạo tài khoản để sử dụng',
                  style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
                ),
                Text(
                  'Đăng ký',
                  style: AppTextStyle.semibold(kTextSizeXxl),
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  text: 'Họ và tên',
                  controller: _nameController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: kMarginMd),
                CustomTextField(
                  text: 'Email',
                  controller: _emailController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: kMarginMd),
                CustomTextField(
                  text: 'Số điện thoại',
                  controller: _emailController,
                  onChanged: (value) {},
                ),
                const SizedBox(height: kMarginMd),
                CustomTextField(
                  text: 'Mật khẩu',
                  controller: _passwordController,
                  isPassword: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: kMarginMd),
                CustomTextField(
                  text: 'Nhập lại mật khẩu',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: kMarginMd),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Mật khẩu phải có ít nhất 8 ký tự bao gồm chữ và số',
                    style: AppTextStyle.regular(kTextSizeXs),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: kMarginLg),
                CustomButton(
                  text: 'Đăng ký',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: kMarginLg),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                      children: <TextSpan>[
                        TextSpan(text: 'Bạn đã có tài khoản? ', style: AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
                        TextSpan(
                          text: 'Đăng nhập',
                          style: AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
