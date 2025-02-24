import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_feature_dialog.dart';
import '../bloc/grade_bloc.dart';
import '../models/grade_model.dart';
import 'widgets/custom_grade_student_list_item.dart';

class GradeStudentListScreen extends StatefulWidget {
  final String studentId;

  const GradeStudentListScreen({super.key, required this.studentId});

  @override
  State<GradeStudentListScreen> createState() => _GradeStudentListScreenState();
}

class _GradeStudentListScreenState extends State<GradeStudentListScreen> {
  String? selectedSubject;
  String? selectedGradeType;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    context
        .read<GradeBloc>()
        .add(GradeFetchByStudentIdStarted(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GradeBloc, GradeState>(
        builder: (context, state) {
          if (state is GradeFetchByStudentIdInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GradeFetchByStudentIdSuccess) {
            List<GradeModel> grades = state.grades;
            grades.sort((a, b) => b.createdAt.compareTo(a.createdAt));

            // Lọc danh sách theo bộ lọc đã chọn
            List<GradeModel> filteredGrades = _filterGrades(grades);

            return Column(
              children: [
                _buildFilterSection(grades),
                Expanded(
                  child: filteredGrades.isEmpty
                      ? const Center(child: Text("Không có dữ liệu điểm."))
                      : ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: kMarginMd,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kPaddingMd),
                          itemCount: filteredGrades.length,
                          itemBuilder: (context, index) {
                            return CustomGradeStudentListItem(
                                grade: filteredGrades[index]);
                          },
                        ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Không có dữ liệu điểm."));
          }
        },
      ),
    );
  }

  List<GradeModel> _filterGrades(List<GradeModel> grades) {
    return grades.where((grade) {
      bool matchesSubject =
          selectedSubject == null || grade.subjectName == selectedSubject;
      bool matchesGradeType =
          selectedGradeType == null || grade.gradeTypeName == selectedGradeType;
      bool matchesDate = (selectedStartDate == null ||
              grade.createdAt.isAfter(selectedStartDate!)) &&
          (selectedEndDate == null ||
              grade.createdAt.isBefore(selectedEndDate!));

      return matchesSubject && matchesGradeType && matchesDate;
    }).toList();
  }

  void _showFeatureDialog(
      BuildContext context, List<String?> options, Function(String?) onSelect) {
    showCustomFeatureDialog(
      context,
      options.map((e) => e ?? "Tất cả").toList(),
      options.map((e) {
        return () {
          onSelect(e);
        };
      }).toList(),
    );
  }

  Widget _buildFilterSection(List<GradeModel> grades) {
    // Danh sách môn học
    Set<String?> subjects = {null, ...grades.map((e) => e.subjectName).toSet()};

    // Lọc danh sách loại điểm theo môn học đã chọn
    Set<String?> gradeTypes = {
      null,
      ...grades
          .where((e) => selectedSubject == null || e.subjectName == selectedSubject)
          .map((e) => e.gradeTypeName)
          .toSet(),
    };

    return Padding(
      padding: const EdgeInsets.all(kPaddingMd),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: selectedSubject ?? "Tất cả môn",
                  icon: Icons.arrow_drop_down,
                  onTap: () {
                    _showFeatureDialog(
                      context,
                      subjects.toList(),
                          (selected) {
                        setState(() {
                          selectedSubject = selected;
                          selectedGradeType = null;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: selectedGradeType ?? "Tất cả loại điểm",
                  icon: Icons.arrow_drop_down,
                  onTap: () {
                    _showFeatureDialog(
                      context,
                      gradeTypes.toList(),
                          (selected) {
                        setState(() {
                          selectedGradeType = selected;
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
