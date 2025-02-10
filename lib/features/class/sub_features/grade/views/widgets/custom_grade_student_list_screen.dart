import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/grade_model.dart';

class CustomGradeStudentListItem extends StatelessWidget {
  final GradeModel grade;

  const CustomGradeStudentListItem({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(grade.createdAt);
    Color gradeColor = _getGradeColor(grade.value);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: gradeColor,
          child: Text(
            grade.value.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          grade.subjectName!,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Loại điểm: ${grade.gradeTypeName}", style: const TextStyle(fontSize: 14)),
            Text("Nhận xét: ${grade.comment}", style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
            Text("Ngày cập nhật: $formattedDate", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  // Hàm lấy màu sắc theo điểm số
  Color _getGradeColor(double value) {
    if (value >= 8.0) return Colors.green;
    if (value >= 5.0) return Colors.orange;
    return Colors.red;
  }
}