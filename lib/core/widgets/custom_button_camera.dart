import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../config/app_constants.dart';

class CustomButtonCamera extends StatefulWidget {
  final ValueChanged<File?> onImagePicked;

  CustomButtonCamera({Key? key, required this.onImagePicked}) : super(key: key);

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
      onTap: () async {
        final pickedFile = await showDialog<File>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Chọn ảnh"),
            actions: [
              TextButton(
                onPressed: () async {
                  final result = await _picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 600,
                    maxHeight: 600,
                  );
                  if (result != null) {
                    Navigator.pop(context, File(result.path));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Chụp ảnh"),
              ),
              TextButton(
                onPressed: () async {
                  final result = await _picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 600,
                    maxHeight: 600,
                  );
                  if (result != null) {
                    Navigator.pop(context, File(result.path));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Chọn ảnh từ thư viện"),
              ),
            ],
          ),
        );

        if (pickedFile != null) {
          setState(() {
            _image = pickedFile;
          });
          widget.onImagePicked(_image);
        }
      },
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
        child: _image == null
            ? const Icon(
          FontAwesomeIcons.camera,
          color: kPrimaryColor,
        )
            : ClipOval(
          child: Image.file(
            _image!,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
      ),
    );
  }
}
