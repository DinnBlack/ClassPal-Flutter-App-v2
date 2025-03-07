import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/views/forgot_password_screen.dart';
import 'package:classpal_flutter_app/features/auth/views/register_screen.dart';
import 'package:classpal_flutter_app/features/auth/views/select_role_screen.dart';
import 'package:classpal_flutter_app/features/auth/views/widgets/custom_button_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/config/app_constants.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValid = false;
  late AnimationController localAnimationController;

  @override
  void initState() {
    super.initState();
    _emailOrPhoneNumberController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailOrPhoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final isEmailValid =
          Validators.validateEmail(_emailOrPhoneNumberController.text) == null;
      final isPhoneValid =
          Validators.validatePhone(_emailOrPhoneNumberController.text) == null;
      final isPasswordValid = Validators.validateRequiredText(
              _passwordController.text, 'Mật khẩu không được bỏ trống') ==
          null;

      _isValid = (isEmailValid || isPhoneValid) &&
          isPasswordValid &&
          _emailOrPhoneNumberController.text.trim().isNotEmpty &&
          _passwordController.text.trim().isNotEmpty;
    });
  }

  Future<void> _openGoogleSignIn() async {
    final Uri googleSignInUrl =
        Uri.parse('https://cpserver.amrakk.rest/api/v1/auth/google');
    final Uri gmailAppUri = Uri.parse('mailto:');

    // Kiểm tra xem có thể mở Gmail không
    if (await canLaunchUrl(gmailAppUri)) {
      await launchUrl(gmailAppUri);
    } else {
      // Nếu không có app Gmail, mở URL đăng nhập Google
      if (await canLaunchUrl(googleSignInUrl)) {
        await launchUrl(googleSignInUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Không thể mở đường dẫn đăng nhập Google.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    isWideScreen ? constraints.maxWidth * 0.2 : kPaddingLg,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    // Giới hạn chiều rộng trên web
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Đăng Nhập',
                            style: AppTextStyle.bold(kTextSizeXl),
                          ),
                          const SizedBox(height: kMarginSm),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Bạn chưa có tài khoản? ',
                                  style: AppTextStyle.medium(kTextSizeXs),
                                ),
                                TextSpan(
                                  text: 'Đăng ký',
                                  style: AppTextStyle.medium(
                                      kTextSizeXs, kPrimaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      if (kIsWeb) {
                                        GoRouter.of(context)
                                            .go('/auth/register');
                                      } else {
                                        CustomPageTransition.navigateTo(
                                            context: context,
                                            page: const RegisterScreen(),
                                            transitionType: PageTransitionType
                                                .slideFromRight);
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: kMarginLg),
                          CustomTextField(
                            text: 'Email hoặc Số điện thoại',
                            controller: _emailOrPhoneNumberController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email hoặc số điện thoại không được để trống';
                              }
                              if (Validators.validateEmail(value) != null &&
                                  Validators.validatePhone(value) != null) {
                                return 'Email hoặc số điện thoại không hợp lệ';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: kMarginMd),
                          CustomTextField(
                            text: 'Mật khẩu',
                            controller: _passwordController,
                            isPassword: true,
                            validator: (value) =>
                                Validators.validateRequiredText(
                                    value, 'Mật khẩu không được bỏ trống'),
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
                                if (kIsWeb) {
                                  GoRouter.of(context).go('/auth/select-role');
                                } else {
                                  CustomPageTransition.navigateTo(
                                      context: context,
                                      page: const SelectRoleScreen(),
                                      transitionType:
                                          PageTransitionType.slideFromRight);
                                }
                              } else if (state is AuthLoginFailure) {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  const CustomSnackBar.error(
                                    message:
                                        'Tài khoản hoặc mật khẩu không đúng! Vui lòng thử lại.',
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                text: 'Đăng nhập',
                                isValid: _isValid,
                                onTap: _isValid
                                    ? () {
                                        if (_formKey.currentState!.validate()) {
                                          final emailOrPhoneNumber =
                                              _emailOrPhoneNumberController
                                                  .text;
                                          final password =
                                              _passwordController.text;

                                          context.read<AuthBloc>().add(
                                                AuthLoginStarted(
                                                  emailOrPhoneNumber:
                                                      emailOrPhoneNumber,
                                                  password: password,
                                                ),
                                              );
                                        }
                                      }
                                    : null,
                              );
                            },
                          ),
                          const SizedBox(height: kMarginLg),
                          GestureDetector(
                            onTap: () {
                              final email =
                                  _emailOrPhoneNumberController.text.trim();
                              if (kIsWeb) {
                                GoRouter.of(context).go('/auth/forgot-password',
                                    extra: {'email': email});
                              } else {
                                CustomPageTransition.navigateTo(
                                    context: context,
                                    page: ForgotPasswordScreen(email: email),
                                    transitionType:
                                        PageTransitionType.slideFromRight);
                              }
                            },
                            child: Text(
                              'Quên mật khẩu?',
                              style: AppTextStyle.medium(
                                  kTextSizeXs, kPrimaryColor),
                            ),
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
                          CustomButtonGoogle(
                            onTap: () {
                              _openGoogleSignIn();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
