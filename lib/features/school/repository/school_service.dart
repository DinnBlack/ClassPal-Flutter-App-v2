import 'package:classpal_flutter_app/features/school/repository/school_data.dart';
import '../../auth/models/user_model.dart';
import '../models/school_model.dart';

class SchoolService {
  // Fetch list of schools for the logged-in user
  Future<List<SchoolModel>> fetchSchoolsByUser(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));
    return sampleSchool_1.where((school) {
      return user.schoolIds.contains(school.schoolId);
    }).toList();
  }

  // Fetch a school by its ID
  Future<SchoolModel?> fetchSchoolById(String schoolId) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return sampleSchool_1.firstWhere(
        (school) => school.schoolId == schoolId,
      );
    } catch (e) {
      return null;
    }
  }
}
