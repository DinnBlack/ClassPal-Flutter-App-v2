import 'package:classpal_flutter_app/features/auth/views/widgets/custom_button_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/config/platform/platform_config.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
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
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneNumberController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final isNameValid = Validators.validateName(_nameController.text) == null;
      final isEmailValid =
          Validators.validateEmail(_emailController.text) == null;
      final isPhoneValid =
          Validators.validatePhone(_phoneNumberController.text) == null;
      final isPasswordValid =
          Validators.validatePassword(_passwordController.text) == null;
      final isConfirmPasswordValid = Validators.validateConfirmPassword(
            _confirmPasswordController.text,
            _passwordController.text,
          ) ==
          null;

      _isValid = isNameValid &&
          isEmailValid &&
          isPhoneValid &&
          isPasswordValid &&
          isConfirmPasswordValid &&
          _nameController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _phoneNumberController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty &&
          _confirmPasswordController.text.trim().isNotEmpty;
    });
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final phoneNumber = _phoneNumberController.text;
      final password = _passwordController.text;

      context.read<AuthBloc>().add(
            AuthRegisterStarted(
              name: name,
              email: email,
              phoneNumber: phoneNumber,
              password: password,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: CustomAppBar(
        leftWidget: InkWell(
          child: const Icon(FontAwesomeIcons.arrowLeft),
          onTap: () {
            if (kIsWeb) {
              goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            // Giới hạn max width
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Đăng ký',
                    style: AppTextStyle.bold(kTextSizeXl),
                  ),
                  const SizedBox(height: kMarginSm),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Bạn đã có tài khoản? ',
                          style: AppTextStyle.medium(kTextSizeXs),
                        ),
                        TextSpan(
                          text: 'Đăng nhập',
                          style:
                              AppTextStyle.medium(kTextSizeXs, kPrimaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (kIsWeb) {
                                GoRouter.of(context).go('/auth/login');
                              } else {
                                Navigator.pop(context);
                              }
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kMarginLg),
                  CustomTextField(
                    text: 'Họ và tên',
                    controller: _nameController,
                    validator: Validators.validateName,
                    onFieldSubmitted: (_) {
                      if (_isValid) _submitRegister();
                    },
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Email',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    onFieldSubmitted: (_) {
                      if (_isValid) _submitRegister();
                    },
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Số điện thoại',
                    isNumber: true,
                    controller: _phoneNumberController,
                    validator: Validators.validatePhone,
                    onFieldSubmitted: (_) {
                      if (_isValid) _submitRegister();
                    },
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Mật khẩu',
                    controller: _passwordController,
                    isPassword: true,
                    validator: Validators.validatePassword,
                    onFieldSubmitted: (_) {
                      if (_isValid) _submitRegister();
                    },
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Nhập lại mật khẩu',
                    controller: _confirmPasswordController,
                    isPassword: true,
                    validator: (value) => Validators.validateConfirmPassword(
                        value, _passwordController.text),
                    onFieldSubmitted: (_) {
                      if (_isValid) _submitRegister();
                    },
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
                        if (kIsWeb) {
                          GoRouter.of(context).go('/auth/login');
                        } else {
                          Navigator.pop(context);
                        }

                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                            message: 'Đăng ký thành công!',
                          ),
                        );
                      } else if (state is AuthRegisterFailure) {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message:
                                'Đăng ký không thành công! Vui lòng kiểm tra lại.',
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Tạo tài khoản',
                        isValid: _isValid,
                        onTap: _isValid ? _submitRegister : null,
                      );
                    },
                  ),
                  const SizedBox(height: kMarginLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Divider(
                          color: kGreyMediumColor,
                          height: 1,
                          thickness: 1,
                          endIndent: kPaddingMd,
                        ),
                      ),
                      Text(
                        'HOẶC',
                        style: AppTextStyle.bold(8, kGreyDarkColor),
                      ),
                      const Expanded(
                        child: Divider(
                          color: kGreyMediumColor,
                          height: 1,
                          thickness: 1,
                          indent: kPaddingMd,
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
      ),
    );
  }
}
