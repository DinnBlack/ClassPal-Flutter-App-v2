import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class CustomNotificationDialog extends StatelessWidget {
  final String title;
  final String description;
  final DialogType dialogType;
  final VoidCallback onCancel;
  final VoidCallback onOk;

  const CustomNotificationDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.dialogType,
    required this.onCancel,
    required this.onOk,
  }) : super(key: key);

  void show(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      title: title,
      desc: description,
      btnCancelOnPress: onCancel,
      btnOkOnPress: onOk,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
