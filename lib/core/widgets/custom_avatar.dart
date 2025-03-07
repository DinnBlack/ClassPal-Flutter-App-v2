import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

import '../config/app_constants.dart';

class CustomAvatar extends StatelessWidget {
  final dynamic profile;
  final String? imageAsset;
  final String? imageUrl;
  final String? text;
  final Color? backgroundColor;
  final double size;

  const CustomAvatar({
    super.key,
    this.profile,
    this.imageAsset,
    this.imageUrl,
    this.text,
    this.backgroundColor,
    this.size = 40.0,
  });

  // Hàm tạo màu ngẫu nhiên
  Color _getRandomColor() {
    return RandomColor().randomColor();
  }

  // Hàm lấy chữ cái đầu của 2 từ cuối cùng trong tên
  String _getInitials(String text) {
    List<String> words = text.trim().split(' ');
    if (words.length > 1) {
      return '${words[words.length - 2][0]}${words.last[0]}'.toUpperCase();
    }
    return words.first[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldUseInitials = (text != null && text!.isNotEmpty) ||
        (profile?.displayName != null && profile.displayName.isNotEmpty);

    final Color avatarBackground = shouldUseInitials
        ? _getRandomColor()
        : kPrimaryColor;

    String initials = shouldUseInitials
        ? _getInitials(text ?? profile?.displayName ?? '')
        : '';

    // Nếu có ảnh, hiển thị ảnh
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      return _buildImageAvatar(Image.asset(imageAsset!));
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl == 'https://i.ibb.co/s224bhZ/profile-icon.png') {
        return _buildInitialsAvatar(initials, avatarBackground);
      } else {
        return _buildImageAvatar(Image.network(imageUrl!));
      }
    }

    // Kiểm tra nếu profile có avatarUrl
    if (profile?.avatarUrl != null && profile?.avatarUrl != 'https://i.ibb.co/s224bhZ/profile-icon.png') {
      return _buildImageAvatar(Image.network(profile!.avatarUrl!));
    }

    // Nếu có text hoặc profile.name, hiển thị chữ cái đầu
    if (shouldUseInitials) {
      return _buildInitialsAvatar(initials, avatarBackground);
    }

    // Mặc định nếu không có gì, vẫn hiển thị nền màu mặc định
    return _buildInitialsAvatar("?", kPrimaryColor);
  }

  Widget _buildImageAvatar(Image image) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor,
      ),
      child: ClipOval(
        child: FittedBox(
          fit: BoxFit.cover,
          child: image,
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials, Color bgColor) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.4,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
