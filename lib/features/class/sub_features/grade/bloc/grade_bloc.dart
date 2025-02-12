import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/class/sub_features/grade/repository/grade_service.dart';
import 'package:meta/meta.dart';

import '../models/grade_model.dart';

part 'grade_event.dart';

part 'grade_state.dart';

class GradeBloc extends Bloc<GradeEvent, GradeState> {
  final GradeService gradeService = GradeService();

  GradeBloc() : super(GradeInitial()) {
    on<GradeCreateInStarted>(_onGradeCreateInStarted);
    on<GradeFetchByStudentIdStarted>(_onGradeFetchByStudentIdStarted);
    on<GradeFetchBySubjectIdStarted>(_onGradeFetchBySubjectIdStarted);
  }

  // insert grade for student
  Future<void> _onGradeCreateInStarted(
      GradeCreateInStarted event, Emitter<GradeState> emit) async {
    emit(GradeCreateInProgress());
    try {
      await gradeService.insertGrade(event.subjectId, event.gradeTypeId,
          event.studentId, event.value, event.comment);
      print("Grade created successfully");
      emit(GradeCreateSuccess());
    } catch (e) {
      emit(GradeCreateFailure("Failed to create Grade: ${e.toString()}"));
    }
  }

  // fetch grades for student
  Future<void> _onGradeFetchByStudentIdStarted(
      GradeFetchByStudentIdStarted event, Emitter<GradeState> emit) async {
    emit(GradeFetchByStudentIdInProgress());
    try {
      List<GradeModel> grades = await gradeService.getGradesByStudentId(event.studentId);
      emit(GradeFetchByStudentIdSuccess(grades));
    } catch (e) {
      emit(GradeFetchByStudentIdFailure("Failed to fetch Grades: ${e.toString()}"));
    }
  }

  // fetch grades for subject
  Future<void> _onGradeFetchBySubjectIdStarted(
      GradeFetchBySubjectIdStarted event, Emitter<GradeState> emit) async {
    emit(GradeFetchBySubjectIdInProgress());
    try {
      List<GradeModel> grades = await gradeService.getGradesBySubjectId(event.subjectId);
      emit(GradeFetchBySubjectIdSuccess(grades));
    } catch (e) {
      emit(GradeFetchBySubjectIdFailure("Failed to fetch Grades: ${e.toString()}"));
    }
  }
}
