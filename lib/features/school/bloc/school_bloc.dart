import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../profile/model/profile_model.dart';
import '../../profile/repository/profile_service.dart';
import '../models/school_model.dart';
import '../repository/school_service.dart';

part 'school_event.dart';

part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolService schoolService = SchoolService();

  SchoolBloc() : super(SchoolInitial()) {
    on<SchoolFetchStarted>(_onSchoolFetchStarted);
    on<SchoolCreateStarted>(_onSchoolCreateStarted);
  }

  Future<void> _onSchoolFetchStarted(
      SchoolFetchStarted event, Emitter<SchoolState> emit) async {
    try {
      emit(SchoolFetchInProgress());
      final result = await schoolService.getAllSchools();
      final profiles = List<ProfileModel>.from(result['profiles'] ?? []);
      final schools = List<SchoolModel>.from(result['schools'] ?? []);

      emit(SchoolFetchSuccess(profiles, schools));
    } on Exception catch (e) {
      emit(SchoolFetchFailure(e.toString()));
    }
  }

  Future<void> _onSchoolCreateStarted(
      SchoolCreateStarted event, Emitter<SchoolState> emit) async {
    try {
      emit(SchoolCreateInProgress());
      await schoolService.insertSchool(
        event.name,
        event.address,
        event.phoneNumber,
        event.avatarUrl,
      );
      emit(SchoolCreateSuccess());
      await ProfileService().getProfilesByRole(['Executive', 'Teacher']);
      add(SchoolFetchStarted());
    } on Exception catch (e) {
      emit(SchoolCreateFailure(e.toString()));
    }
  }
}
