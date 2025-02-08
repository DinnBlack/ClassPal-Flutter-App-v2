import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/class/sub_features/subject/models/subject_model.dart';
import 'package:meta/meta.dart';

import '../repository/subject_service.dart';

part 'subject_event.dart';

part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final SubjectService subjectService = SubjectService();

  SubjectBloc() : super(SubjectInitial()) {
    on<SubjectFetchStarted>(_onSubjectFetchStarted);
    on<SubjectCreateStarted>(_onSubjectCreateStarted);
  }

  // Fetch the list of group
  Future<void> _onSubjectFetchStarted(
      SubjectFetchStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectFetchInProgress());
    try {
      final subjects = await subjectService.getAllSubject();
      emit(SubjectFetchSuccess(subjects));
    } catch (e) {
      emit(SubjectFetchFailure("Failed to fetch students: ${e.toString()}"));
    }
  }

  // Insert a new subject
  Future<void> _onSubjectCreateStarted(
      SubjectCreateStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectCreateInProgress());
    try {
      await subjectService.insertSubject(event.name, event.gradeTypes);
      print("Subject created successfully");
      emit(SubjectCreateSuccess());
      add(SubjectFetchStarted());
    } catch (e) {
      emit(SubjectCreateFailure("Failed to create subject: ${e.toString()}"));
    }
  }
}
