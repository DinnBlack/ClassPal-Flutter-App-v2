import '../../class/repository/class_data.dart';
import '../../principal/repository/principal_data.dart';
import '../../teacher/repository/teacher_data.dart';
import '../models/school_model.dart';

List<SchoolModel> sampleSchool_1 = [
  SchoolModel(
    schoolId: 'SCH001',
    name: 'Tiểu học A Long Bình',
    address: 'Thị Trấn Long bình, Huyện An Phú, Tỉnh An Giang',
    createdDate: DateTime(2020, 5, 20),
    teachers: sampleTeacher_1,
    principals: samplePrincipal_1,
    classes: sampleClass_1,
  ),
];
