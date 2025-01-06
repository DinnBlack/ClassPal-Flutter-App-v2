import 'package:classpal_flutter_app/features/student/repository/student_data.dart';
import 'package:classpal_flutter_app/features/teacher/repository/teacher_data.dart';

import '../models/class_model.dart';

final sampleClass_1 = [
  ClassModel(
    className: '10A1',
    teachers: [sampleTeacher_1[0], sampleTeacher_1[1]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: sampleStudent_1,
    schedule: [],
  ),
  ClassModel(
    className: '10A2',
    teachers: [sampleTeacher_1[3], sampleTeacher_1[4]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: [],
    schedule: [],
  ),
];