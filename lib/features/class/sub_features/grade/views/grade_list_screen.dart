import 'package:classpal_flutter_app/core/config/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<GradeBloc>().add(GradeFetchBySubjectIdStarted(widget.subject.id));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: kPaddingMd),
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
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16, ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimaryLightColor : Colors.white,
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
                      color: isSelected ? kWhiteColor : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Danh sách điểm
        Expanded(
          child: BlocBuilder<GradeBloc, GradeState>(
            builder: (context, state) {
              if (state is GradeFetchBySubjectIdInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is GradeFetchBySubjectIdSuccess) {
                List<GradeModel> filteredGrades = selectedGradeType == null
                    ? state.grades
                    : state.grades.where((g) => g.gradeTypeName == selectedGradeType).toList();

                return filteredGrades.isEmpty
                    ? const Center(child: Text("Chưa có điểm cho loại điểm này"))
                    : ListView.separated(
                  itemCount: filteredGrades.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    GradeModel grade = filteredGrades[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        title: Text(
                          grade.studentName ?? "Unknown Student",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              "${grade.gradeTypeName ?? "Unknown Type"} - ${grade.subjectName ?? "Unknown Subject"}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Updated: ${grade.updatedAt.toLocal().toString().split(" ")[0]}",
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ],
                        ),
                        leading: CircleAvatar(
                          backgroundColor: grade.value >= 5 ? Colors.green : Colors.red,
                          radius: 25,
                          child: Text(
                            grade.value.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                        trailing: Icon(
                          Icons.star,
                          color: grade.value >= 8 ? Colors.amber : Colors.grey,
                        ),
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text("No data available", style: TextStyle(fontSize: 16)));
            },
          ),
        ),
      ],
    );
  }
}
