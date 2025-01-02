import 'package:flutter/material.dart';
import '../../models/student_model.dart';

class CustomStudentAvatar extends StatelessWidget {
  final StudentModel? student;
  final double? size;

  const CustomStudentAvatar({
    super.key,
    required this.student,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: student?.avatar != null
              ? NetworkImage(student!.avatar!)
              : AssetImage(
                  student?.gender == 'Male'
                      ? 'assets/images/boy.jpg'
                      : 'assets/images/girl.jpg',
                ) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
