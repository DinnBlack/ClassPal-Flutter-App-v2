import 'package:classpal_flutter_app/core/widgets/custom_bottom_sheet.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/views/otp_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading_dialog.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../bloc/auth_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;
  static const route = 'ForgotPasswordScreen';

  const ForgotPasswordScreen({super.key, required this.email});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      final isEmailValid =
          Validators.validateEmail(_emailController.text) == null;
      _isValid = isEmailValid && _emailController.text.trim().isNotEmpty;
    });
  }

  void _submitForgotPassword() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      context.read<AuthBloc>().add(AuthForgotPasswordStarted(email: email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: kIsWeb
          ? null
          : CustomAppBar(
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quên mật khẩu',
                    style: AppTextStyle.bold(kTextSizeXl),
                  ),
                  const SizedBox(height: kMarginSm),
                  Text(
                    'Nhập email để khôi phục tài khoản',
                    style: AppTextStyle.medium(kTextSizeXs),
                  ),
                  const SizedBox(height: kMarginLg),
                  CustomTextField(
                    text: 'Email',
                    controller: _emailController,
                    validator: Validators.validateEmail,
                    onFieldSubmitted: (_) => _submitForgotPassword(),
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
                        final email = _emailController.text.trim();
                        if (kIsWeb) {
                          GoRouter.of(context).go('/auth/otp', extra: {'email': email});
                        } else {
                          CustomPageTransition.navigateTo(
                            context: context,
                            page: OtpScreen(email: email),
                            transitionType: PageTransitionType.slideFromRight,
                          );
                        }
                      } else if (state is AuthForgotPasswordFailure) {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Khôi phục tài khoản thất bại!',
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Khôi phục lại mật khẩu',
                        isValid: _isValid,
                        onTap: _isValid ? _submitForgotPassword : null,
                      );
                    },
                  ),
                  const SizedBox(height: kMarginLg),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Bạn nhớ mật khẩu? ',
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
