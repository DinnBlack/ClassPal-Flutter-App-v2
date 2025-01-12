import 'package:classpal_flutter_app/core/widgets/custom_bottom_sheet.dart';
import 'package:classpal_flutter_app/features/auth/views/otp_screen.dart';
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

class ForgotPasswordScreen extends StatefulWidget {
  static const route = 'ForgotPasswordScreen';

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

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
                  'Quên mật khẩu',
                  style: AppTextStyle.semibold(kTextSizeXxl),
                ),
                Text(
                  'Nhập vào email của bạn',
                  style: AppTextStyle.semibold(kTextSizeMd, kGreyColor),
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  text: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: kMarginLg),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthForgotPasswordInProgress) {
                      CustomLoadingDialog.show(context);
                    } else {
                      CustomLoadingDialog.dismiss(context);
                    }
                    if (state is AuthForgotPasswordSuccess) {
                      CustomBottomSheet.showCustomBottomSheet(
                          context, OtpScreen(email: _emailController.text));
                    } else if (state is AuthForgotPasswordFailure) {
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
                        final email = _emailController.text;
                        context.read<AuthBloc>().add(
                              AuthForgotPasswordStarted(
                                email: email,
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
