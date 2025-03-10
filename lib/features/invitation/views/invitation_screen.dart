import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/views/login_screen.dart';
import 'package:classpal_flutter_app/features/auth/views/select_role_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../bloc/invitation_bloc.dart';

class InvitationScreen extends StatelessWidget {
  final String token;

  const InvitationScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: _buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPaddingLg),
          child: BlocListener<InvitationBloc, InvitationState>(
            listener: (context, state) async {
              if (state is InvitationAcceptInProgress) {
                CustomLoadingDialog.show(context);
              } else {
                CustomLoadingDialog.dismiss(context);
              }

              if (state is InvitationAcceptSuccess) {
                // Hiển thị thông báo thành công
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    message: 'Tham gia lớp học thành công!',
                  ),
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

                if (isLoggedIn) {
                  if (kIsWeb) {
                    GoRouter.of(context).go('/auth/select-role');
                  } else {
                    CustomPageTransition.navigateTo(
                        context: context,
                        page: const SelectRoleScreen(),
                        transitionType: PageTransitionType.slideFromRight);
                  }
                } else {
                  if (kIsWeb) {
                    GoRouter.of(context).go('/auth/login');
                  } else {
                    CustomPageTransition.navigateTo(
                        context: context,
                        page: const LoginScreen(),
                        transitionType: PageTransitionType.slideFromRight);
                  }
                }
              } else if (state is InvitationAcceptFailure) {
                // Hiển thị thông báo lỗi nếu thất bại
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: 'Tham gia lớp học thất bại!',
                  ),
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/accept_mail.jpg',
                  height: 200,
                ),
                const SizedBox(height: kMarginLg),
                Text(
                  'Chấp nhận tham gia lớp học!',
                  style: AppTextStyle.bold(kTextSizeLg),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kMarginSm),
                Text(
                  "Chào mừng bạn đến với ClassPal! Hãy tham gia lớp học của bạn",
                  style: AppTextStyle.medium(kTextSizeXs),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: kMarginLg),

                // BlocBuilder để cập nhật UI khi thay đổi trạng thái
                SizedBox(
                  width: 650,
                  child: BlocBuilder<InvitationBloc, InvitationState>(
                    builder: (context, state) {
                      bool isLoading = state is InvitationAcceptInProgress;

                      return CustomButton(
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<InvitationBloc>().add(
                                    InvitationAcceptStarted(
                                        invitationId: token));
                              },
                        text: isLoading
                            ? 'Đang tham gia...'
                            : "Chấp nhận lời mời",
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'Tham gia lớp học',
      leftWidget: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          FontAwesomeIcons.xmark,
        ),
      ),
    );
  }
}
