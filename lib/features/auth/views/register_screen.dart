import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../core/widgets/custom_loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  static const route = 'RegisterScreen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailOrPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Họ và tên không được để trống';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    } else if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    } else if (value.length < 8) {
      return 'Mật khẩu phải có ít nhất 8 ký tự';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
            child: Form(
              key: _formKey,
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
                    validator: _validateName,
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Email hoặc Số điện thoại',
                    controller: _emailOrPhoneNumberController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Mật khẩu',
                    controller: _passwordController,
                    isPassword: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Nhập lại mật khẩu',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: _validateConfirmPassword,
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
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthRegisterInProgress) {
                        CustomLoadingDialog.show(context);
                      } else {
                        CustomLoadingDialog.dismiss(context);
                      }

                      if (state is AuthRegisterSuccess) {
                        Navigator.pop(context);
                      } else if (state is AuthRegisterFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đăng ký thất bại')),
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Đăng ký',
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            final name = _nameController.text;
                            final emailOrPhoneNumber = _emailOrPhoneNumberController.text;
                            final password = _passwordController.text;

                            context.read<AuthBloc>().add(
                              AuthRegisterStarted(
                                name: name,
                                emailOrPhoneNumber: emailOrPhoneNumber,
                                password: password,
                              ),
                            );
                          }
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
      ),
    );
  }
}
