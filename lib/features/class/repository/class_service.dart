import '../../auth/models/user_model.dart';
import '../models/class_model.dart';
import 'class_data.dart';

class ClassService {
  // Fetch list of classs for the logged-in user
  Future<List<ClassModel>> fetchClassesByUser(UserModel user) async {
    await Future.delayed(const Duration(seconds: 2));
    return sampleClass_1.where((currentClass) {
    return true;
    }).toList();
  }

  // Fetch a class by its ID
  Future<ClassModel?> fetchClassById(String classId) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return sampleClass_1.firstWhere(
        (currentClass) => currentClass.name == classId,
      );
    } catch (e) {
      return null;
    }
  }
}
