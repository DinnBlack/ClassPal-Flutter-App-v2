import 'package:classpal_flutter_app/features/student/models/student_model.dart';

class StudentGroupModel {
  final List<StudentModel> students;
  final String groupName;

//<editor-fold desc="Data Methods">
  const StudentGroupModel({
    required this.students,
    required this.groupName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudentGroupModel &&
          runtimeType == other.runtimeType &&
          students == other.students &&
          groupName == other.groupName);

  @override
  int get hashCode => students.hashCode ^ groupName.hashCode;

  @override
  String toString() {
    return 'StudentGroupModel{' +
        ' students: $students,' +
        ' groupName: $groupName,' +
        '}';
  }

  StudentGroupModel copyWith({
    List<StudentModel>? students,
    String? groupName,
  }) {
    return StudentGroupModel(
      students: students ?? this.students,
      groupName: groupName ?? this.groupName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'students': this.students,
      'groupName': this.groupName,
    };
  }

  factory StudentGroupModel.fromMap(Map<String, dynamic> map) {
    return StudentGroupModel(
      students: map['students'] as List<StudentModel>,
      groupName: map['groupName'] as String,
    );
  }

//</editor-fold>
}