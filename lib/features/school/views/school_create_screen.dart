import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/core/utils/app_text_style.dart';
import 'package:classpal_flutter_app/core/widgets/custom_button.dart';
import 'package:classpal_flutter_app/core/widgets/custom_text_field.dart';
import 'package:classpal_flutter_app/features/school/views/school_join_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/utils/validators.dart';
import '../bloc/school_bloc.dart';
import '../../../core/widgets/custom_loading_dialog.dart';

class SchoolCreateScreen extends StatefulWidget {
  static const route = 'SchoolCreateScreen';

  const SchoolCreateScreen({super.key});

  @override
  _SchoolCreateScreenState createState() => _SchoolCreateScreenState();
}

class _SchoolCreateScreenState extends State<SchoolCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: BlocListener<SchoolBloc, SchoolState>(
        listener: (context, state) {
          if (state is SchoolCreateInProgress) {
            CustomLoadingDialog.show(context);
          } else {
            CustomLoadingDialog.dismiss(context);
          }

          if (state is SchoolCreateSuccess) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.success(
                message: 'Tạo trường học thành công!',
              ),
            );
            Navigator.pop(context);
          } else if (state is SchoolCreateFailure) {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: 'Tạo trường học thất bại!',
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: kMarginLg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: const Icon(FontAwesomeIcons.arrowLeft),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: kMarginLg),
                  Text(
                    'Chào mừng lãnh đạo trường!',
                    style: AppTextStyle.bold(kTextSizeXxl),
                  ),
                  Text(
                    'Hãy tạo trường học của bạn để quản lý',
                    style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                  ),
                  const SizedBox(height: kMarginLg),
                  CustomTextField(
                    text: 'Tên trường học',
                    controller: _nameController,
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Địa chỉ',
                    controller: _addressController,
                  ),
                  const SizedBox(height: kMarginMd),
                  CustomTextField(
                    text: 'Số điện thoại',
                    controller: _phoneController,
                    isNumber: true,
                    validator: (value) => Validators.validatePhone(value),
                  ),
                  const SizedBox(height: kMarginLg),
                  CustomButton(
                    text: 'Tạo trường học',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SchoolBloc>().add(
                              SchoolCreateStarted(
                                name: _nameController.text,
                                address: _addressController.text,
                                phoneNumber: _phoneController.text,
                              ),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: kMarginLg),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Bạn đã được mời từ trường học? ',
                            style:
                                AppTextStyle.semibold(kTextSizeSm, kGreyColor),
                          ),
                          TextSpan(
                            text: 'Tham gia',
                            style: AppTextStyle.semibold(
                                kTextSizeSm, kPrimaryColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, SchoolJoinScreen.route);
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

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
