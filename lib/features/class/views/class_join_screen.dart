import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:classpal_flutter_app/features/invitation/repository/invitation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ClassJoinScreen extends StatefulWidget {
  final bool isStudentView;
  static const route = 'ClassJoinScreen';
  final VoidCallback? onJoinSuccess;

  const ClassJoinScreen(
      {super.key, this.isStudentView = false, this.onJoinSuccess});

  @override
  State<ClassJoinScreen> createState() => _ClassJoinScreenState();
}

class _ClassJoinScreenState extends State<ClassJoinScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  void _joinClass(String code) async {
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập mã lớp học')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await InvitationService().submitGroupCode(code);
      if (success) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(message: 'Tham gia lớp thành công!'),
        );

        widget.onJoinSuccess?.call();
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Mã lớp không hợp lệ!',
          ),
        );
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'Lỗi: $e',
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: kMarginLg),
              if (!widget.isStudentView)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: const Icon(FontAwesomeIcons.arrowLeft),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              const SizedBox(height: kMarginLg),
              Text(
                widget.isStudentView
                    ? 'Xin chào Học sinh'
                    : 'Chào mừng Giáo viên!',
                style: AppTextStyle.bold(kTextSizeXxl),
              ),
              Text(
                'Hãy quét mã QR hoặc nhập mã để tham gia',
                style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
              ),
              const SizedBox(height: kMarginLg),
              if (!kIsWeb) ...[
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadiusMd),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kBorderRadiusMd),
                    child: MobileScanner(
                      onDetect: (capture) {
                        final barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          final String? code = barcode.rawValue;
                          if (code != null) {
                            _codeController.text = code;
                            _joinClass(code);
                          }
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: kMarginLg),
                Text(
                  'Hoặc',
                  style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                ),
              ],
              const SizedBox(height: kMarginLg),
              CustomTextField(
                controller: _codeController,
                text: 'Nhập mã lớp học',
              ),
              const SizedBox(height: kMarginLg),
              CustomButton(
                text: _isLoading ? 'Đang xử lý...' : 'Tham gia lớp',
                onTap:
                    _isLoading ? null : () => _joinClass(_codeController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
