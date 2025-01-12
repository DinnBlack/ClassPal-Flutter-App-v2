import 'package:classpal_flutter_app/features/auth/views/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  static const route = 'ResetPasswordScreen';

  const ResetPasswordScreen({super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
                  'Mật khẩu mới',
                  style: AppTextStyle.semibold(kTextSizeXxl),
                ),
                Text(
                  'Thiết lập mật khẩu mới của bạn',
                  style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  text: 'Mật khẩu',
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  text: 'Nhập lại mật khẩu',
                  isPassword: true,
                  controller: _confirmPasswordController,
                ),
                const SizedBox(height: kMarginLg),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthResetPasswordInProgress) {
                      CustomLoadingDialog.show(context);
                    } else {
                      CustomLoadingDialog.dismiss(context);
                    }
                    if (state is AuthResetPasswordSuccess) {
                      Navigator.pop(context);
                    } else if (state is AuthResetPasswordFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Khôi phục tài khoản thất bại')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Khôi phục lại mật khẩu',
                      onTap: () {
                        final password = _passwordController.text;
                        context.read<AuthBloc>().add(
                          AuthResetPasswordStarted(
                            email: widget.email,
                            otp: widget.otp,
                            password: password,
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: kMarginLg),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Bạn nhớ mật khẩu? ',
                            style:
                            AppTextStyle.semibold(kTextSizeSm, kGreyColor)),
                        TextSpan(
                          text: 'Đăng nhập',
                          style:
                          AppTextStyle.semibold(kTextSizeSm, kPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.route);
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
