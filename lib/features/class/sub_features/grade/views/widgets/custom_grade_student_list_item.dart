import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/config/app_constants.dart';
import '../../models/grade_model.dart';

class CustomGradeStudentListItem extends StatelessWidget {
  final GradeModel grade;

  const CustomGradeStudentListItem({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kGreyLightColor,
      ),
      child: Container(
        padding: const EdgeInsets.all(kPaddingMd),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: kWhiteColor,
            border: Border.all(width: 2, color: kGreyLightColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubjectAndType(), // 📚 Môn học & Loại điểm
            const SizedBox(height: 8),
            Row(
              children: [
                _buildGradeBox(grade.value),
                // 🏆 Hộp điểm số
                const SizedBox(width: 12),
                Expanded(child: _buildDetails()),
                // ℹ️ Thông tin học sinh, ngày, nhận xét
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📚 Môn học & Loại điểm (Hiển thị to, dễ nhìn)
  Widget _buildSubjectAndType() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: grade.subjectName ?? "Môn không xác định"),
          const TextSpan(
              text: "  •  ",
              style:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
          TextSpan(
              text: grade.gradeTypeName ?? "Loại không xác định",
              style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  // 🏆 Hộp điểm số
  Widget _buildGradeBox(double value) {
    Color gradeColor = _getGradeColor(value);
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: gradeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        value.toStringAsFixed(1),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: gradeColor,
        ),
      ),
    );
  }

  // ℹ️ Chi tiết (Học sinh, ngày, nhận xét)
  Widget _buildDetails() {
    String formattedDate = DateFormat('dd/MM/yyyy').format(grade.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (grade.studentName != null && grade.studentName!.isNotEmpty)
          _buildStudentName(),
        _buildDate(formattedDate),
        if (grade.comment != null && grade.comment!.isNotEmpty) _buildComment(),
      ],
    );
  }

  // 👤 Tên học sinh
  Widget _buildStudentName() {
    return Text(
      "👤 ${grade.studentName}",
      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
    );
  }

  // 📅 Ngày tạo
  Widget _buildDate(String formattedDate) {
    return Text(
      "📅 Ngày: $formattedDate",
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  // 📝 Nhận xét
  Widget _buildComment() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        "📝 ${grade.comment}",
        style: TextStyle(
            fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87),
      ),
    );
  }

  // 🎨 Hàm lấy màu sắc theo điểm số
  Color _getGradeColor(double value) {
    if (value >= 8.0) return Colors.green;
    if (value >= 5.0) return Colors.orange;
    return Colors.red;
  }
}
