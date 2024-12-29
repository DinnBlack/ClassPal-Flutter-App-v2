import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class CustomAvatar extends StatelessWidget {
  final String? imageAsset;
  final String? text;
  final Color backgroundColor;
  final double size;

  const CustomAvatar({
    Key? key,
    this.imageAsset,
    this.text,
    this.backgroundColor = kPrimaryColor,
    this.size = 40.0,
  }) : super(key: key);

  String _getInitials(String text) {
    List<String> words = text.trim().split(' ');
    return words.length > 1
        ? '${words.first[0]}${words.last[0]}'.toUpperCase()
        : words.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: ClipOval(
        child: imageAsset != null
            ? Image.asset(
          imageAsset!,
          fit: BoxFit.cover,
        )
            : Center(
          child: Text(
            text != null ? _getInitials(text!) : '',
            style: TextStyle(
              fontSize: size * 0.4,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
