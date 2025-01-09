import 'package:flutter/material.dart';
import '../config/app_constants.dart';

class CustomAvatar extends StatelessWidget {
  final dynamic user;
  final String? imageAsset;
  final Color backgroundColor;
  final double size;

  const CustomAvatar({
    Key? key,
    this.user,
    this.imageAsset,
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
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: ClipOval(
          child: Image.asset(
            imageAsset!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    String avatarUrl = user?.avatar ?? '';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? Image.network(
          avatarUrl,
          fit: BoxFit.cover,
        )
            : Center(
          child: Text(
            _getInitials(user?.name ?? ''),
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
