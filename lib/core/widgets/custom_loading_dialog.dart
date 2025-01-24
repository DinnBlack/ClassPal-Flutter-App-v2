import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingDialog extends StatelessWidget {
  const CustomLoadingDialog({super.key});

  static bool _isDialogShown = false;

  static void show(BuildContext context) {
    if (!_isDialogShown) {
      _isDialogShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomLoadingDialog();
        },
      );
    }
  }

  static void dismiss(BuildContext context) {
    if (_isDialogShown) {
      _isDialogShown = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(70),
          child: Container(
             width: 50,
            padding: const EdgeInsets.all(kPaddingLg),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(kBorderRadiusXl),
              border: Border.all(width: 2, color: kPrimaryColor),
            ),
            child: Lottie.asset(
              'assets/animations/loading.json',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
