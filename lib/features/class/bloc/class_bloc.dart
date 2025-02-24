import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:classpal_flutter_app/features/profile/repository/profile_service.dart';
import 'package:meta/meta.dart';
import '../../profile/model/profile_model.dart';
import '../models/class_model.dart';
import '../repository/class_service.dart';

part 'class_event.dart';

part 'class_state.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService classService = ClassService();

  ClassBloc() : super(ClassInitial()) {
    on<ClassPersonalFetchStarted>(_onClassPersonalFetchStarted);
    on<ClassSchoolFetchStarted>(_onClassSchoolFetchStarted);
    on<ClassPersonalCreateStarted>(_onClassPersonalCreateStarted);
    on<ClassSchoolCreateStarted>(_onClassSchoolCreateStarted);
    on<ClassUpdateStarted>(_onClassUpdateStarted);
    on<ClassDeleteStarted>(_onClassDeleteStarted);
    on<ClassSchoolBindRelStarted>(_onClassSchoolBindRelStarted);
    on<ClassSchoolUnBindRelStarted>(_onClassSchoolUnBindRelStarted);
    on<ClassCreateBatchStarted>(_onClassCreateBatchStarted);
  }

  // Fetch the list of classes personal
  Future<void> _onClassPersonalFetchStarted(
      ClassPersonalFetchStarted event, Emitter<ClassState> emit) async {
    emit(ClassPersonalFetchInProgress());
    try {
      final result = await classService.getAllClassPersonal();
      final profiles = result['profiles'] as List<ProfileModel>;
      final classes = result['classes'] as List<ClassModel>;

      emit(ClassPersonalFetchSuccess(profiles, classes));
    } catch (e) {
      emit(ClassPersonalFetchFailure(
          "Failed to fetch classes: ${e.toString()}"));
    }
  }

  // Fetch the list of classes school
  Future<void> _onClassSchoolFetchStarted(
      ClassSchoolFetchStarted event, Emitter<ClassState> emit) async {
    emit(ClassSchoolFetchInProgress());
    try {
      final classes = await classService.getAllClassSchool();
      emit(ClassSchoolFetchSuccess(classes));
    } catch (e) {
      emit(ClassSchoolFetchFailure("Failed to fetch classes: ${e.toString()}"));
    }
  }

  // Create a new class personal
  Future<void> _onClassPersonalCreateStarted(
      ClassPersonalCreateStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassPersonalCreateInProgress());
      await classService.insertPersonalClass(
        event.name,
        event.avatarUrl,
      );
      emit(ClassPersonalCreateSuccess());
      await ProfileService().getProfilesByRole(['Executive', 'Teacher']);
      add(ClassPersonalFetchStarted());
    } on Exception catch (e) {
      emit(ClassPersonalCreateFailure(e.toString()));
    }
  }

  // Create a new class school
  Future<void> _onClassSchoolCreateStarted(
      ClassSchoolCreateStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassSchoolCreateInProgress());
      final result = await classService.insertSchoolClass(event.name, event.avatarUrl);
      emit(ClassSchoolCreateSuccess(result));
      add(ClassSchoolFetchStarted());
    } on Exception catch (e) {
      emit(ClassSchoolCreateFailure(e.toString()));
    }
  }

  // Update a class
  Future<void> _onClassUpdateStarted(
      ClassUpdateStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassUpdateInProgress());
      await classService.updateClass(
        event.newName,
      );
      emit(ClassUpdateSuccess());
    } on Exception catch (e) {
      emit(ClassUpdateFailure(e.toString()));
    }
  }

  // Delete a class
  Future<void> _onClassDeleteStarted(
      ClassDeleteStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassDeleteInProgress());
      await classService.deleteClass(event.classId);
      emit(ClassDeleteSuccess());
      await ProfileService().getProfilesByRole(['Executive', 'Teacher']);
      add(ClassPersonalFetchStarted());
    } on Exception catch (e) {
      emit(ClassDeleteFailure(e.toString()));
    }
  }

  // Bind a class to a school
  Future<void> _onClassSchoolBindRelStarted(
      ClassSchoolBindRelStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassSchoolBindRelInProgress());
      await classService.bindRelationship(event.profileIds);
      emit(ClassSchoolBindRelSuccess());
    } on Exception catch (e) {
      emit(ClassSchoolBindRelFailure(e.toString()));
    }
  }

  // Unbind a class from a school
  Future<void> _onClassSchoolUnBindRelStarted(
      ClassSchoolUnBindRelStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassSchoolUnBindRelInProgress());
      await classService.bindRelationship(event.profileIds);
      emit(ClassSchoolUnBindRelSuccess());
    } on Exception catch (e) {
      emit(ClassSchoolUnBindRelFailure(e.toString()));
    }
  }

  // Create multiple classes
  Future<void> _onClassCreateBatchStarted(
      ClassCreateBatchStarted event, Emitter<ClassState> emit) async {
    try {
      emit(ClassCreateBatchInProgress());
      await classService.insertBatchClass(event.classes);
      emit(ClassCreateBatchSuccess());
      await ProfileService().getProfilesByRole(['Executive', 'Teacher']);
      add(ClassPersonalFetchStarted());
    } on Exception catch (e) {
      emit(ClassCreateBatchFailure(e.toString()));
    }
  }
}
