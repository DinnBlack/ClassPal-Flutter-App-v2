import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/grade_bloc.dart';
import '../models/grade_model.dart';
import 'widgets/custom_grade_student_list_screen.dart';

class GradeStudentListScreen extends StatefulWidget {
  final String studentId;

  const GradeStudentListScreen({super.key, required this.studentId});

  @override
  State<GradeStudentListScreen> createState() => _GradeStudentListScreenState();
}

class _GradeStudentListScreenState extends State<GradeStudentListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GradeBloc>().add(GradeFetchByStudentIdStarted(widget.studentId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GradeBloc, GradeState>(
      builder: (context, state) {
        if (state is GradeFetchByStudentIdInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GradeFetchByStudentIdSuccess) {
          List<GradeModel> grades = state.grades;
          grades.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: grades.length,
            itemBuilder: (context, index) {
              return CustomGradeStudentListItem(grade: grades[index]);
            },
          );
        } else {
          return const Center(child: Text("Không có dữ liệu điểm."));
        }
      },
    );
  }
}
