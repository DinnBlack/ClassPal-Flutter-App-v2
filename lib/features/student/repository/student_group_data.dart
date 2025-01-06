import '../models/student_group_model.dart';
import 'student_data.dart';

List<StudentGroupModel> studentGroups = [
  StudentGroupModel(
    students: [
      sampleStudent_1[0],
      sampleStudent_1[3],
      sampleStudent_1[4],
      sampleStudent_1[6],
      sampleStudent_1[8],
    ],
    groupName: "Group A (Female)",
  ),
  StudentGroupModel(
    students: [
      sampleStudent_1[1],
      sampleStudent_1[2],
      sampleStudent_1[5],
      sampleStudent_1[7],
      sampleStudent_1[9],
    ],
    groupName: "Group B (Male)",
  ),
  StudentGroupModel(
    students: [
      sampleStudent_1[10],
      sampleStudent_1[11],
      sampleStudent_1[12],
    ],
    groupName: "Group C (Mixed)",
  ),
  StudentGroupModel(
    students: [
      sampleStudent_1[0],
      sampleStudent_1[1],
      sampleStudent_1[2],
      sampleStudent_1[3],
    ],
    groupName: "Group D (First Year)",
  ),
  StudentGroupModel(
    students: [
      sampleStudent_1[4],
      sampleStudent_1[5],
      sampleStudent_1[6],
      sampleStudent_1[7],
    ],
    groupName: "Group E (Second Year)",
  ),
];