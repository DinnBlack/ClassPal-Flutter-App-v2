import 'package:bloc/bloc.dart';
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
    on<ClassPersonalCreateStarted>(_onClassPersonalCreateStarted);
    on<ClassUpdateStarted>(_onClassUpdateStarted);
  }

  // Fetch the list of classes personal
  Future<void> _onClassPersonalFetchStarted(
      ClassPersonalFetchStarted event, Emitter<ClassState> emit) async {
    emit(ClassPersonalFetchInProgress());
    try {
      final result = await classService.getAllPersonalClass();
      final profiles = result['profiles'] as List<ProfileModel>;
      final classes = result['classes'] as List<ClassModel>;

      print(profiles);
      print(classes);

      emit(ClassPersonalFetchSuccess(profiles, classes));
    } catch (e) {
      emit(ClassPersonalFetchFailure(
          "Failed to fetch classes: ${e.toString()}"));
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
    } on Exception catch (e) {
      emit(ClassPersonalCreateFailure(e.toString()));
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
}
