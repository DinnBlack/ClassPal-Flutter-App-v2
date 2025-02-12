import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:classpal_flutter_app/features/class/sub_features/grade/bloc/grade_bloc.dart';
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
    context.read<GradeBloc>().add(GradeFetchBySubjectIdStarted(widget.subject.id));
  }

  void _sortGrades(List<GradeModel> grades) {
    switch (_sortOption) {
      case "Tên học sinh":
        grades.sort((a, b) => (a.studentName ?? "").compareTo(b.studentName ?? ""));
        break;
      case "Điểm số":
        grades.sort((a, b) => b.value.compareTo(a.value));
        break;
      case "Ngày cập nhật":
        grades.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilterBar(),
        _buildSortDropdown(),
        const SizedBox(height: kMarginMd,),
        Expanded(
          child: BlocBuilder<GradeBloc, GradeState>(
            builder: (context, state) {
              if (state is GradeFetchBySubjectIdInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GradeFetchBySubjectIdSuccess) {
                List<GradeModel> filteredGrades = selectedGradeType == null
                    ? state.grades
                    : state.grades.where((g) => g.gradeTypeName == selectedGradeType).toList();

                _sortGrades(filteredGrades);

                return filteredGrades.isEmpty
                    ? const Center(child: Text("Chưa có điểm cho loại điểm này"))
                    : ListView.separated(
                  padding: const EdgeInsets.all(kPaddingMd),
                  itemCount: filteredGrades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildGradeCard(filteredGrades[index]);
                  },
                );
              }
              return const Center(child: Text("Không có dữ liệu", style: TextStyle(fontSize: 16)));
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
                selectedGradeType = index == 0 ? null : widget.subject.gradeTypes[index - 1].name;
              });
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? kPrimaryColor : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Text(
                index == 0 ? "Tất cả" : widget.subject.gradeTypes[index - 1].name,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Sắp xếp theo:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
      ),
    );
  }

  Widget _buildGradeCard(GradeModel grade) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              grade.studentName ?? "Unknown Student",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${grade.gradeTypeName} - ${grade.subjectName}",
                    style: TextStyle(color: Colors.grey[700])),
                CircleAvatar(
                  backgroundColor: grade.value >= 5 ? Colors.green : Colors.red,
                  radius: 22,
                  child: Text(
                    grade.value.toString(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Cập nhật: ${grade.updatedAt.toLocal().toString().split(" ")[0]}",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
            if (grade.comment != null && grade.comment!.isNotEmpty) ...[
              const Divider(),
              Text("Nhận xét: ${grade.comment}",
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey)),
            ],
          ],
        ),
      ),
    );
  }
}