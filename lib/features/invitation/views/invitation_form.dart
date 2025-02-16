import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/widgets/custom_app_bar.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/app_text_style.dart';
import '../bloc/invitation_bloc.dart';

class InvitationForm extends StatefulWidget {
  final String? subtitle;
  final String profileId;
  final String role;

  const InvitationForm({
    super.key,
    this.subtitle,
    required this.profileId,
    required this.role,
  });

  @override
  _InvitationFormState createState() => _InvitationFormState();
}

class _InvitationFormState extends State<InvitationForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.elasticOut,
          ),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadiusXl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(kPaddingMd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomAppBar(
                    title: 'Gửi lời mời',
                    isSafeArea: false,
                    subtitle: widget.subtitle,
                    leftWidget: InkWell(
                      child: const Icon(
                        FontAwesomeIcons.xmark,
                      ),
                      onTap: () {
                        if (_emailController.text.isNotEmpty) {
                          _showExitConfirmationDialog(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    controller: _emailController,
                    text: 'Email hoặc số điện thoại',
                    autofocus: true,
                  ),
                  const SizedBox(height: kMarginLg),
                  CustomButton(
                    text: 'Mời',
                    onTap: () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        context.read<InvitationBloc>().add(
                              InvitationCreateStarted(
                                role: widget.role,
                                profileId: '67a476001d0557e69365678d',
                                email: email,
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: kMarginMd),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void showInvitationForm(
    BuildContext context, String profileId, String role, String? subtitle) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    pageBuilder: (context, animation, secondaryAnimation) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: Material(
              color: Colors.transparent,
              child: InvitationForm(
                profileId: profileId,
                role: role,
                subtitle: subtitle,
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}

void _showExitConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Xác nhận'),
        content:
            const Text('Bạn có chắc chắn muốn thoát? Nội dung nhập sẽ bị mất.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng dialog xác nhận
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog xác nhận
              Navigator.pop(context); // Đóng InvitationForm
            },
            child: const Text('Thoát'),
          ),
        ],
      );
    },
  );
}
