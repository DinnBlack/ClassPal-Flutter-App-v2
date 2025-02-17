import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class CustomAvatar extends StatelessWidget {
  final dynamic profile;
  final String? imageAsset;
  final String? imageUrl;
  final String? text;
  final Color? backgroundColor;
  final double size;

  const CustomAvatar({
    Key? key,
    this.profile,
    this.imageAsset,
    this.imageUrl,
    this.text,
    this.backgroundColor,
    this.size = 40.0,
  }) : super(key: key);

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
    final Color avatarBackground = backgroundColor ?? _getRandomColor(); // Chỉ sinh màu nếu backgroundColor không được truyền

    // Nếu có ảnh, hiển thị ảnh
    if (imageAsset != null && imageAsset!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatarBackground,
        ),
        child: ClipOval(
          child: Image.asset(
            imageAsset!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Check if the avatarUrl is equal to the default placeholder image
      if (imageUrl == 'https://i.ibb.co/s224bhZ/profile-icon.png') {
        // Use initials if the avatar URL matches the placeholder
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBackground,
          ),
          child: Center(
            child: Text(
              _getInitials(text ?? profile?.displayName ?? ''), // Use initials based on name or text
              style: TextStyle(
                fontSize: size * 0.4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        // Show the image if the URL is not the placeholder
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBackground,
          ),
          child: ClipOval(
            child: Image.network(
              imageUrl!,
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    }

    // Nếu có text, sử dụng text để lấy chữ cái đầu
    if (text != null && text!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: avatarBackground, // Sử dụng màu từ backgroundColor hoặc ngẫu nhiên
        ),
        child: Center(
          child: Text(
            _getInitials(text!), // Lấy chữ cái đầu
            style: TextStyle(
              fontSize: size * 0.4,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Nếu không có text và không có ảnh, hiển thị chữ cái đầu của tên trong profile
    String avatarUrl = profile?.avatarUrl ?? '';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: avatarBackground, // Sử dụng màu từ backgroundColor hoặc ngẫu nhiên
      ),
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? avatarUrl == 'https://i.ibb.co/s224bhZ/profile-icon.png'
        // Check if the URL is the placeholder and use initials
            ? Center(
          child: Text(
            _getInitials(profile?.displayName ?? ''),
            style: TextStyle(
              fontSize: size * 0.4,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : Image.network(
          avatarUrl,
          fit: BoxFit.cover,
        )
            : Center(
          child: Text(
            _getInitials(profile?.displayName ?? ''), // Lấy chữ cái từ profile.name
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
