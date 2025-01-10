import '../../class/models/class_model.dart';
import '../models/student_model.dart';

class StudentService {
// Fetch students by ClassModel
  Future<List<StudentModel>> fetchStudentsByClass(
      ClassModel currentClass) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      return currentClass.students;
    } catch (e) {
      return [];
    }
  }
}
