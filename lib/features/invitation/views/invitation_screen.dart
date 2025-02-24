import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_loading_dialog.dart';
import 'package:classpal_flutter_app/core/widgets/custom_page_transition.dart';
import 'package:classpal_flutter_app/features/auth/repository/auth_service.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              const Icon(Icons.mail_outline, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                "Bạn đã nhận được một lời mời!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                "Mã lời mời: $token",
                style: AppTextStyle.medium(kTextSizeSm),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // BlocBuilder để cập nhật UI khi thay đổi trạng thái
              BlocBuilder<InvitationBloc, InvitationState>(
                builder: (context, state) {
                  bool isLoading = state is InvitationAcceptInProgress;

                  return CustomButton(
                    onTap: isLoading
                        ? null
                        : () {
                            context.read<InvitationBloc>().add(
                                InvitationAcceptStarted(invitationId: token));
                          },
                    text: isLoading ? 'Đang tham gia...' : "Chấp nhận lời mời",
                  );
                },
              ),
            ],
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
