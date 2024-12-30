import '../models/student_group_model.dart';
import 'student_data.dart';

List<StudentGroupModel> studentGroups = [
  StudentGroupModel(
    students: [
      students[0],
      students[3],
      students[4],
      students[6],
      students[8],
    ],
    groupName: "Group A (Female)",
  ),
  StudentGroupModel(
    students: [
      students[1],
      students[2],
      students[5],
      students[7],
      students[9],
    ],
    groupName: "Group B (Male)",
  ),
  StudentGroupModel(
    students: [
      students[10],
      students[11],
      students[12],
    ],
    groupName: "Group C (Mixed)",
  ),
  StudentGroupModel(
    students: [
      students[0],
      students[1],
      students[2],
      students[3],
    ],
    groupName: "Group D (First Year)",
  ),
  StudentGroupModel(
    students: [
      students[4],
      students[5],
      students[6],
      students[7], 
    ],
    groupName: "Group E (Second Year)",
  ),
];