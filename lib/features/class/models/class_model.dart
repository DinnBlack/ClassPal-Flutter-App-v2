import 'package:classpal_flutter_app/features/student/models/student_group_model.dart';

import '../../student/models/student_model.dart';
import '../../teacher/models/teacher_model.dart';
import '../sub_features/attendance/models/atttendance_model.dart';
import '../sub_features/schedule/models/schedule_model.dart';

class ClassModel {
  final String classId;
  final String name;
  final String avatar;
  final List<TeacherModel> teachers;
  final DateTime creationDate;
  final Map<DateTime, List<AttendanceModel>> attendanceRecords;
  final List<StudentModel> students;
  final List<ScheduleModel> schedule;
  final List<StudentGroupModel> studentGroups;

//<editor-fold desc="Data Methods">
  const ClassModel({
    required this.classId,
    required this.name,
    required this.avatar,
    required this.teachers,
    required this.creationDate,
    required this.attendanceRecords,
    required this.students,
    required this.schedule,
    required this.studentGroups,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClassModel &&
          runtimeType == other.runtimeType &&
          classId == other.classId &&
          name == other.name &&
          avatar == other.avatar &&
          teachers == other.teachers &&
          creationDate == other.creationDate &&
          attendanceRecords == other.attendanceRecords &&
          students == other.students &&
          schedule == other.schedule &&
          studentGroups == other.studentGroups);

  @override
  int get hashCode =>
      classId.hashCode ^
      name.hashCode ^
      avatar.hashCode ^
      teachers.hashCode ^
      creationDate.hashCode ^
      attendanceRecords.hashCode ^
      students.hashCode ^
      schedule.hashCode ^
      studentGroups.hashCode;

  @override
  String toString() {
    return 'ClassModel{' +
        ' classId: $classId,' +
        ' name: $name,' +
        ' avatar: $avatar,' +
        ' teachers: $teachers,' +
        ' creationDate: $creationDate,' +
        ' attendanceRecords: $attendanceRecords,' +
        ' students: $students,' +
        ' schedule: $schedule,' +
        ' studentGroups: $studentGroups,' +
        '}';
  }

  ClassModel copyWith({
    String? classId,
    String? name,
    String? avatar,
    List<TeacherModel>? teachers,
    DateTime? creationDate,
    Map<DateTime, List<AttendanceModel>>? attendanceRecords,
    List<StudentModel>? students,
    List<ScheduleModel>? schedule,
    List<StudentGroupModel>? studentGroups,
  }) {
    return ClassModel(
      classId: classId ?? this.classId,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      teachers: teachers ?? this.teachers,
      creationDate: creationDate ?? this.creationDate,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      students: students ?? this.students,
      schedule: schedule ?? this.schedule,
      studentGroups: studentGroups ?? this.studentGroups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': this.classId,
      'name': this.name,
      'avatar': this.avatar,
      'teachers': this.teachers,
      'creationDate': this.creationDate,
      'attendanceRecords': this.attendanceRecords,
      'students': this.students,
      'schedule': this.schedule,
      'studentGroups': this.studentGroups,
    };
  }

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      classId: map['classId'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      teachers: map['teachers'] as List<TeacherModel>,
      creationDate: map['creationDate'] as DateTime,
      attendanceRecords:
          map['attendanceRecords'] as Map<DateTime, List<AttendanceModel>>,
      students: map['students'] as List<StudentModel>,
      schedule: map['schedule'] as List<ScheduleModel>,
      studentGroups: map['studentGroups'] as List<StudentGroupModel>,
    );
  }

//</editor-fold>
}

