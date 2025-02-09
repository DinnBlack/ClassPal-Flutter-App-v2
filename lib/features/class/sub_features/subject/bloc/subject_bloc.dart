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
    on<SubjectUpdateStarted>(_onSubjectUpdateStarted);
    on<SubjectDeleteStarted>(_onSubjectDeleteStarted);
    on<SubjectFetchByIdStarted>(_onSubjectFetchByIdStarted);
  }

  // Fetch the list of group
  Future<void> _onSubjectFetchStarted(
      SubjectFetchStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectFetchInProgress());
    try {
      final subjects = await subjectService.getAllSubject();
      emit(SubjectFetchSuccess(subjects));
    } catch (e) {
      emit(SubjectFetchFailure("Failed to fetch subjects: ${e.toString()}"));
    }
  }

  // Fetch a single subject by id
  Future<void> _onSubjectFetchByIdStarted(
      SubjectFetchByIdStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectFetchByIdInProgress());
    try {
      final subject = await subjectService.getSubjectById(event.subjectId);
      emit(SubjectFetchByIdSuccess(subject!));
    } catch (e) {
      emit(SubjectFetchByIdFailure("Failed to fetch subject: ${e.toString()}"));
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

  // Update an existing subject
  Future<void> _onSubjectUpdateStarted(
      SubjectUpdateStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectUpdateInProgress());
    try {
      await subjectService.updateSubject(
          event.subject, event.name, event.gradeTypes);
      print("Subject updated successfully");
      emit(SubjectUpdateSuccess());
      add(SubjectFetchByIdStarted(event.subject.id));
      add(SubjectFetchStarted());

    } catch (e) {
      emit(SubjectUpdateFailure("Failed to update subject: ${e.toString()}"));
    }
  }

  // Delete a subject
  Future<void> _onSubjectDeleteStarted(
      SubjectDeleteStarted event, Emitter<SubjectState> emit) async {
    emit(SubjectDeleteInProgress());
    try {
      await subjectService.deleteSubject(event.subjectId);
      print("Subject deleted successfully");
      emit(SubjectDeleteSuccess());
      add(SubjectFetchStarted());
    } catch (e) {
      emit(SubjectDeleteFailure("Failed to delete subject: ${e.toString()}"));
    }
  }
}
