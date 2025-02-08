import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_constants.dart';

class CustomButtonCamera extends StatefulWidget {
  final ValueChanged<File?> onImagePicked;
  final String? initialImageUrl;

  CustomButtonCamera(
      {Key? key, required this.onImagePicked, this.initialImageUrl})
      : super(key: key);

  @override
  _CustomButtonCameraState createState() => _CustomButtonCameraState();
}

class _CustomButtonCameraState extends State<CustomButtonCamera> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImagePicked(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      splashColor: kPrimaryColor.withAlpha(30),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: kPrimaryColor,
            width: 2,
          ),
        ),
        child: _image != null
            ? ClipOval(
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              )
            : (widget.initialImageUrl != null &&
                    widget.initialImageUrl!.isNotEmpty)
                ? ClipOval(
                    child: (widget.initialImageUrl != null &&
                            widget.initialImageUrl!.isNotEmpty)
                        ? widget.initialImageUrl ==
                                "https://i.ibb.co/V9Znq7h/class-icon.png"
                            ? ClipOval(
                                child: Image.asset(
                                  "assets/images/class.jpg",
                                  // Đường dẫn asset trong dự án của bạn
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              )
                            : ClipOval(
                                child: Image.network(
                                  widget.initialImageUrl!,
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(FontAwesomeIcons.camera,
                                        color: kPrimaryColor);
                                  },
                                ),
                              )
                        : const Icon(FontAwesomeIcons.camera,
                            color: kPrimaryColor),
                  )
                : const Icon(
                    FontAwesomeIcons.camera,
                    color: kPrimaryColor,
                  ),
      ),
    );
  }
}
