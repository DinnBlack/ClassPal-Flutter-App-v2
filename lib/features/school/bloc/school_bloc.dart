import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/school_model.dart';
import '../repository/school_service.dart';
import '../../auth/models/user_model.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolService schoolService = SchoolService();

  SchoolBloc() : super(SchoolInitial()) {
    on<SchoolFetchByUserStarted>(_onSchoolFetchByUserStarted);
    on<SchoolFetchByIdStarted>(_onSchoolFetchByIdStarted);
  }

  // Fetch the list of schools for the logged-in user
  Future<void> _onSchoolFetchByUserStarted(
      SchoolFetchByUserStarted event, Emitter<SchoolState> emit) async {
    emit(SchoolFetchByUserInProgress());
    try {
      final schools = await schoolService.fetchSchoolsByUser(event.user);
      emit(SchoolFetchByUserSuccess(schools));
    } catch (e) {
      emit(SchoolFetchByUserFailure("Failed to fetch schools: ${e.toString()}"));
    }
  }

  // Fetch a school by its ID
  Future<void> _onSchoolFetchByIdStarted(
      SchoolFetchByIdStarted event, Emitter<SchoolState> emit) async {
    emit(SchoolFetchByIdInProgress());
    try {
      final school = await schoolService.fetchSchoolById(event.schoolId);
      if (school != null) {
        emit(SchoolFetchByIdSuccess(school));
      } else {
        emit(SchoolFetchByIdFailure("School not found"));
      }
    } catch (e) {
      emit(SchoolFetchByIdFailure("Failed to fetch school: ${e.toString()}"));
    }
  }
}
