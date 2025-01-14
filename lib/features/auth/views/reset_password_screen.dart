import 'package:classpal_flutter_app/features/auth/views/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;
  static const route = 'ResetPasswordScreen';

  const ResetPasswordScreen(
      {super.key, required this.email, required this.otp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final isPasswordValid =
          Validators.validatePassword(_passwordController.text) == null;
      final isConfirmPasswordValid = Validators.validateConfirmPassword(
              _confirmPasswordController.text, _passwordController.text) ==
          null;

      _isValid = isPasswordValid &&
          _passwordController.text.trim().isNotEmpty &&
          isConfirmPasswordValid &&
          _confirmPasswordController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Đặt lại mật khẩu',
              style: AppTextStyle.bold(kTextSizeXl),
            ),
            const SizedBox(height: kMarginSm),
            Text(
              'thiết lập mật khẩu mới của bạn',
              style: AppTextStyle.medium(kTextSizeXs),
            ),
            const SizedBox(height: kMarginLg),
            CustomTextField(
              text: 'Mật khẩu',
              isPassword: true,
              controller: _passwordController,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: kMarginLg),
            CustomTextField(
              text: 'Nhập lại mật khẩu',
              isPassword: true,
              controller: _confirmPasswordController,
              validator: (value) => Validators.validateConfirmPassword(
                  value, _passwordController.text),
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.route,
                    (route) => false,
                  );
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
                  isValid: _isValid,
                  onTap: _isValid
                      ? () {
                          final password = _passwordController.text;
                          context.read<AuthBloc>().add(
                                AuthResetPasswordStarted(
                                  email: widget.email,
                                  otp: widget.otp,
                                  password: password,
                                ),
                              );
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
