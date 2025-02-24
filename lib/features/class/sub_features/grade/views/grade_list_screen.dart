import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/class/sub_features/grade/bloc/grade_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_text_style.dart';
import '../../subject/bloc/subject_bloc.dart';
import '../models/grade_model.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/models/subject_model.dart';

class GradeListScreen extends StatefulWidget {
  final SubjectModel subject;

  const GradeListScreen({super.key, required this.subject});

  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  String? selectedGradeType;
  String _sortOption = "Tên học sinh";

  @override
  void initState() {
    super.initState();
    context
        .read<GradeBloc>()
        .add(GradeFetchBySubjectIdStarted(widget.subject.id));
  }

  void _sortGrades(List<GradeModel> grades) {
    switch (_sortOption) {
      case "Tên học sinh":
        grades.sort(
            (a, b) => (a.studentName ?? "").compareTo(b.studentName ?? ""));
        break;
      case "Điểm số":
        grades.sort((a, b) => b.value.compareTo(a.value));
        break;
      case "Ngày cập nhật":
        grades.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
  }

  void _deleteGrade(GradeModel grade) {
    _showConfirmDialog(
      title: "Xác nhận xóa",
      content: "Bạn có chắc muốn xóa điểm này không?",
      onConfirm: () {
        context.read<GradeBloc>().add(GradeDeleteStarted(widget.subject.id, grade.id));
      },
    );
  }

  void _showConfirmDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại xác nhận
                onConfirm(); // Gọi hành động xác nhận
              },
              child: const Text("Xác nhận", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }



  void _editGrade(GradeModel grade) {
    TextEditingController scoreController =
        TextEditingController(text: grade.value.toString());
    TextEditingController commentController =
        TextEditingController(text: grade.comment ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Chỉnh sửa điểm"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Điểm số"),
              ),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(labelText: "Nhận xét"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                double newScore =
                    double.tryParse(scoreController.text) ?? grade.value;
                String newComment = commentController.text;

                context.read<GradeBloc>().add(GradeUpdateStarted(
                      subjectId: widget.subject.id,
                      gradeId: grade.id,
                      value: newScore,
                      comment: newComment,
                    ));

                Navigator.pop(context);
              },
              child: const Text("Lưu",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        _buildSortDropdown(),
        Expanded(
          child: BlocBuilder<GradeBloc, GradeState>(
            builder: (context, state) {
              if (state is GradeFetchBySubjectIdInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GradeFetchBySubjectIdSuccess) {
                List<GradeModel> filteredGrades = selectedGradeType == null
                    ? state.grades
                    : state.grades
                        .where((g) => g.gradeTypeName == selectedGradeType)
                        .toList();

                _sortGrades(filteredGrades);
                return filteredGrades.isEmpty
                    ? const Center(
                        child: Text("Chưa có điểm cho loại điểm này"))
                    : ListView.separated(
                        itemCount: filteredGrades.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: kMarginMd),
                        itemBuilder: (context, index) {
                          return _buildGradeCard(filteredGrades[index]);
                        },
                      );
              }
              return const Center(
                  child:
                      Text("Không có dữ liệu", style: TextStyle(fontSize: 16)));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.subject.gradeTypes.length + 1,
        itemBuilder: (context, index) {
          final isSelected = index == 0
              ? selectedGradeType == null
              : selectedGradeType == widget.subject.gradeTypes[index - 1].name;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedGradeType = index == 0
                    ? null
                    : widget.subject.gradeTypes[index - 1].name;
              });
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(right: kMarginMd),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Text(
                index == 0
                    ? "Tất cả"
                    : widget.subject.gradeTypes[index - 1].name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Sắp xếp theo:", style: AppTextStyle.semibold(kTextSizeSm)),
        DropdownButton<String>(
          value: _sortOption,
          onChanged: (String? newValue) {
            setState(() {
              _sortOption = newValue!;
            });
          },
          items: ["Tên học sinh", "Điểm số", "Ngày cập nhật"]
              .map((String option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
        ),
      ],
    );
  }

  void _showGradeOptionsDialog(GradeModel grade) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tùy chọn điểm"),
          content: const Text("Bạn muốn thực hiện thao tác nào?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteGrade(grade);
              },
              child:
                  const Text("Xóa điểm", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editGrade(grade);
              },
              child: const Text("Chỉnh sửa"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGradeCard(GradeModel grade) {
    return GestureDetector(
      onLongPress: () => _showGradeOptionsDialog(grade),
      child: Container(
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
              _buildSubjectAndType(grade),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGradeBox(grade.value),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDetails(grade)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectAndType(GradeModel grade) {
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

  Widget _buildDetails(GradeModel grade) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(grade.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (grade.studentName != null && grade.studentName!.isNotEmpty)
          _buildStudentName(grade.studentName!),
        _buildDate(formattedDate),
        if (grade.comment != null && grade.comment!.isNotEmpty)
          _buildComment(grade.comment!),
      ],
    );
  }

  Widget _buildStudentName(String studentName) {
    return Text(
      "👤 $studentName",
      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
    );
  }

  Widget _buildDate(String formattedDate) {
    return Text(
      "📅 Ngày: $formattedDate",
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  Widget _buildComment(String comment) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        "📝 $comment",
        style: TextStyle(
            fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87),
      ),
    );
  }

  Color _getGradeColor(double value) {
    if (value >= 8.0) return Colors.green;
    if (value >= 5.0) return Colors.orange;
    return Colors.red;
  }
}
