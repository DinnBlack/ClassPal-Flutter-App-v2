import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'select_role_screen.dart';
import 'widgets/custom_button_google.dart';

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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  style: AppTextStyle.bold(kTextSizeXl),
                ),
                const SizedBox(height: kMarginSm),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Bạn chưa có tài khoản? ',
                          style: AppTextStyle.medium(kTextSizeXs)),
                      TextSpan(
                        text: 'Đăng ký',
                        style: AppTextStyle.medium(kTextSizeXs, kPrimaryColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RegisterScreen.route);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  // title: 'Tên đăng nhập',
                  text: 'Email hoặc số điện thoại',
                  controller: _emailOrPhoneNumberController,
                ),
                const SizedBox(height: kMarginLg),
                CustomTextField(
                  // title: 'Mật khẩu',
                  text: 'Mật khẩu',
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: kMarginLg),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLoginInProgress) {
                      CustomLoadingDialog.show(context);
                    } else {
                      CustomLoadingDialog.dismiss(context);
                    }
                    if (state is AuthLoginSuccess) {
                      Navigator.pushNamed(context, SelectRoleScreen.route,
                          arguments: {'user': state.user});
                    } else if (state is AuthLoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đăng nhập thất bại')),
                      );
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Đăng nhập',
                      onTap: () {
                        final emailOrPhoneNumber =
                            _emailOrPhoneNumberController.text;
                        final password = _passwordController.text;
                        context.read<AuthBloc>().add(
                              AuthLoginStarted(
                                emailOrPhoneNumber: emailOrPhoneNumber,
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPasswordScreen.route);
                    },
                    child: Text(
                      'Quên mật khẩu?',
                      style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                    ),
                  ),
                ),
                const SizedBox(height: kMarginLg),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: kGreyColor,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kPaddingMd),
                      child: Text(
                        'HOẶC',
                        style: AppTextStyle.medium(kTextSizeXs, kGreyColor),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: kGreyColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kMarginLg),
                const CustomButtonGoogle(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
