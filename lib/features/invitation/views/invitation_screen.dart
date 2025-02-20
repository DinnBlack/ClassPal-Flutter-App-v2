import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/views/select_role_screen.dart';
import '../bloc/invitation_bloc.dart';

class InvitationScreen extends StatelessWidget {
  final String token;

  const InvitationScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lời mời")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<InvitationBloc, InvitationState>(
          listener: (context, state) {
            if (state is InvitationAcceptSuccess) {
              // Điều hướng về màn hình SelectRoleScreen khi thành công
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SelectRoleScreen()),
              );
            } else if (state is InvitationAcceptFailure) {
              // Hiển thị thông báo lỗi nếu thất bại
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Lỗi: ${state.error}"),
                  backgroundColor: Colors.red,
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
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Token: $token",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // BlocBuilder để cập nhật UI khi thay đổi trạng thái
              BlocBuilder<InvitationBloc, InvitationState>(
                builder: (context, state) {
                  bool isLoading = state is InvitationAcceptInProgress;

                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      // Gửi sự kiện Accept Invitation
                      context.read<InvitationBloc>().add(InvitationAcceptStarted(invitationId: token));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Chấp nhận lời mời",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
