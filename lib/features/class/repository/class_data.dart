import 'package:classpal_flutter_app/features/student/repository/student_data.dart';
import 'package:classpal_flutter_app/features/teacher/repository/teacher_data.dart';

import '../models/class_model.dart';

final sampleClass_1 = [
  ClassModel(
    classId: 'CLA001',
    name: '10A1',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_1[0], sampleTeacher_1[1]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: [],
    schedule: [],
  ),
  ClassModel(
    classId: 'CLA002',
    name: '10A2',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_1[3], sampleTeacher_1[4]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: [],
    schedule: [],
  ),
];

final sampleClass_2 = [
  ClassModel(
    classId: 'CLA003',
    name: '4A1',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_2[0], sampleTeacher_2[1]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: sampleStudent_1,
    schedule: [],
  ),
  ClassModel(
    classId: 'CLA004',
    name: '4A2',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_2[3], sampleTeacher_2[4]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: [],
    schedule: [],
  ),
];

final sampleClass_3 = [
  ClassModel(
    classId: 'CLA005',
    name: '5A1',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_3[0], sampleTeacher_3[1]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: sampleStudent_1,
    schedule: [],
  ),
  ClassModel(
    classId: 'CLA006',
    name: '6A2',
    avatar: 'assets/images/class.png',
    teachers: [sampleTeacher_3[3], sampleTeacher_3[4]],
    creationDate: DateTime(2023, 1, 6),
    attendanceRecords: {},
    students: [],
    schedule: [],
  ),
];
